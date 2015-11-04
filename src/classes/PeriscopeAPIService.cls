@RestResource(urlMapping='/periscope/*')
global with sharing class PeriscopeAPIService {
    
    @HttpPost
    global static PeriscopeResult doPost(PeriscopeRequest data) {
        ////////////////////////////////////////
        //// post handler for periscope api ////
        //// calls the account handler /////////
        ////////////////////////////////////////

        try {
            //braintree id must be included in request body
            if(data.braintree_id != null) {
                AccountService.manageAccounts(data.braintree_id, data.name);
            }
            else {
                throw new PeriscopeException('Braintree Id cannot be null');
            }
        } catch(Exception e) {
            //catch exception into result object
            return new PeriscopeResult(400, e.getMessage(), e.getTypeName());
        }

        return new PeriscopeResult(200, 'Success', null);
    }

    global class PeriscopeRequest {
        public String braintree_id;
        public String name;
    }

    global class PeriscopeResult {
        public Integer status_code;
        public String status;
        public String exceptionType;

        public PeriscopeResult(Integer sc, String s, String et) {
            this.status_code   = sc;
            this.status        = s;
            this.exceptionType = et;
        }
    }
}