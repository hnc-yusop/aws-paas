exports.handler = (event, context, callback) => {

    const https = require('https');

    // Send post authentication data to Cloudwatch logs
    console.log ("Authentication successful");
    console.log ("Trigger function =", event.triggerSource);
    console.log ("User pool = ", event.userPoolId);
    console.log ("App client ID = ", event.callerContext.clientId);
    console.log ("User ID = ", event.userName);
    console.log ("User email : ", event.request.userAttributes.name);
    
    var tmp1 = event.request.userAttributes.name;
    var tmp2 = tmp1.replace(/[.]/g, '-');
    var tmp3 = tmp2.replace(/@/g, '-');
    
    var projectName = "prj-" + tmp3;
    
    console.log ("Project name : ", projectName);

    
    // Setup your service account token 
    //var token = '';
    
    // prepare the header
    var headers = {
        'Authorization' : 'Bearer ' + token,
        'Accept' : 'application/json',
        'Content-Type' : 'application/json'
    };
    
    var jsonProject = JSON.stringify({
        "kind": "ProjectRequest",
        "metadata": { "name": projectName }
    });


    // the post options
    var optionsProject = {
        host : 'api.okd.okd-newworld.ml',
        port : 6443,
        path : '/apis/project.openshift.io/v1/projectrequests',
        method : 'POST',
        rejectUnauthorized: false,
        headers : headers
    };

    console.info('Options prepared:');
    console.info(optionsProject);
    console.info('Do the POST call');

    // do the POST call
    var reqPost = https.request(optionsProject, function(res) {
        console.log("statusCode: ", res.statusCode);

        res.on('data', function(d) {
            console.info('POST result:\n');
            process.stdout.write(d);
            console.info('\n\nPOST completed');
            
            /*start*****************************************/
            var jsonRollbinding = JSON.stringify({
                "kind": "RoleBinding",
                "metadata": {
                    "name": "admin"
                },
                "subjects": [
                    {
                        "kind": "User",
                        "name": tmp1
                    }
                ],
                "roleRef": {
                    "name": "admin"
                }
            });

            // the put options
            var optionsRollbinding = {
                host : 'api.okd.okd-newworld.ml',
                port : 6443,
                path : '/apis/authorization.openshift.io/v1/namespaces/' + projectName + '/rolebindings/admin',
                method : 'PUT',
                rejectUnauthorized: false,
                headers : headers
            };

            console.info('Options prepared:');
            console.info(optionsRollbinding);
            console.info('Do the PUT call');

            // do the PUT call
            var reqPut = https.request(optionsRollbinding, function(res) {
                console.log("statusCode: ", res.statusCode);

                res.on('data', function(d) {
                    console.info('PUT result:\n');
                    process.stdout.write(d);
                    console.info('\n\nPUT completed');
                });
            });
    
            // write the json data
            reqPut.write(jsonRollbinding);
            reqPut.end();
            reqPut.on('error', function(e) {
                console.error(e);
            });
            /*end*****************************************/
        });
    });

    // write the json data
    reqPost.write(jsonProject);
    reqPost.end();
    reqPost.on('error', function(e) {
        console.error(e);
    });


    // Return to Amazon Cognito
    callback(null, event);
};
