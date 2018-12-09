import ballerina/http;
import ballerina/log;
import ballerinax/docker;

http:AuthProvider basicAuthProvider = { id: "basic1", scheme: "basic", authStoreProvider: "config" };
http:ServiceSecureSocket secureSocket = {
    keyStore: {
        path: "${ballerina.home}/bre/security/ballerinaKeystore.p12",
        password: "ballerina"
    }
};
@docker:Config {
    registry: "riyafa",
    name: "company_recruitment_agency_service",
    tag: "v1.0"
}

@docker:Expose {

}

@docker:CopyFiles {
    files: [{
            source: "users.conf",
            target: "users.conf",
            isBallerinaConf: true
    }]
}
listener http:Listener comEP = new http:Listener(9091, config = {authProviders: [basicAuthProvider], secureSocket: secureSocket});

//Client endpoint to communicate with company recruitment service
http:Client locationEP = new("http://data-service:9090/companies");

//Service is invoked using basePath value "/checkVacancies"
@http:ServiceConfig {
    basePath: "/checkVacancies"
}
//"comapnyRecruitmentsAgency" routes requests to relevant endpoints and gets their responses.
service comapnyRecruitmentsAgency on comEP {

    // GET requests is directed to a specific company using, /checkVacancies/company.
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/company/{name}",
        authConfig: {
                scopes: ["website"]
        }
    }
    resource function comapnyRecruitmentsAgency(http:Caller CompanyEP, http:Request req, string name) {

        //The HTTP response can be either error|empty|clientResponse
        (    http:Response | error | ()) clientResponse;

        if (name == "JAndB") {
            //Routes the payload to the relevant service.
            clientResponse = locationEP->get("/John-and-Brothers-(pvt)-Ltd");

        } else if (name == "ABC") {
            clientResponse = locationEP->get("/ABC-Company");

        } else if (name == "SA") {
            clientResponse = locationEP->get("/Smart-Automobile");

        } else {
            http:Response resp = new;
            resp.setJsonPayload({
                "^error": "Invalid request"
            });
            resp.statusCode = 400;
            clientResponse = resp;
        }

        //Use respond() to send the client response back to the caller.
        //When the request is successful, the response is returned.
        //Sends back the clientResponse to the caller if no error is found.
        if (clientResponse is http:Response) {
            var err = CompanyEP->respond(clientResponse);
            if (err is error) {
                log:printError("Error sending response", err = err);
            }
        } else if (clientResponse is error) {
            http:Response res = new;
            res.statusCode = 500;
            res.setJsonPayload({
                "^error": "Error when fetching the desired data"
            });
            var err = CompanyEP->respond(res);
            if (err is error) {
                log:printError("Error sending response", err = err);
            }
        }
    }
}