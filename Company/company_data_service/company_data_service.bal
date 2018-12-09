import ballerina/http;
import ballerina/log;
import ballerinax/docker;

@docker:Config {
    registry: "riyafa",
    name: "company_data_service",
    tag: "v1.0"
}
@docker:Expose {

}
listener http:Listener httpListener = new http:Listener(9090);

// RESTful service.
@http:ServiceConfig {
    basePath: "/companies"
}
service orderMgt on httpListener {
    // Resource that handles the HTTP GET requests that are directed to data of a specific
    // company using path '/John-and-Brothers-(pvt)-Ltd'
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/John-and-Brothers-(pvt)-Ltd"
    }
    resource function findJohnAndBrothersPvtLtd(http:Caller caller, http:Request req) {
        json payload = {
            Name: "John and Brothers (pvt) Ltd",
            Total_number_of_Vacancies: 12,
            Available_job_roles: "Senior Software Engineer = 3 ,Marketing Executives = 5 Management Trainees = 4",
            CV_Closing_Date: "17/06/2018",
            ContactNo: 1123456,
            Email_Address: "careersjohn@jbrothers.com"
        };

        // Send response to the caller.
        var err = caller->respond(payload);
        handleErrorWhenResponding(err);
    }

    // Resource that handles the HTTP GET requests that are directed to data
    // of a specific company using path '/ABC-Company'
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/ABC-Company"
    }
    resource function findAbcCompany(http:Caller caller, http:Request req) {
        json payload = {
            Name: "ABC Company",
            Total_number_of_Vacancies: 10,
            Available_job_roles: "Senior Finance Manager = 2 ,Marketing Executives = 6 HR Manager = 2",
            CV_Closing_Date: "20/07/2018",
            ContactNo: 112774,
            Email_Address: "careers@abc.com"
        };

        // Send response to the client.
        var err = caller->respond(payload);
        handleErrorWhenResponding(err);
    }

    // Resource that handles the HTTP GET requests that are directed to a specific
    // company data of company using path '/Smart-Automobile'
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/Smart-Automobile"
    }
    resource function findSmartAutomobile(http:Caller caller, http:Request req) {
        json payload = {
            Name: "Smart Automobile",
            Total_number_of_Vacancies: 11,
            Available_job_roles: "Senior Finance Manager = 2 ,Marketing Executives = 6 HR Manager = 3",
            CV_Closing_Date: "20/07/2018",
            ContactNo: 112774,
            Email_Address: "careers@smart.com"
        };

        // Send response to the client.
        var err = caller->respond(payload);
        handleErrorWhenResponding(err);
    }
}

function handleErrorWhenResponding(error? err) {
    if (err is error) {
        log:printError("Error when responding", err = err);
    }
}
