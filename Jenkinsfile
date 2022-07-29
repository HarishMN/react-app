pipeline {
     agent any
     stages {
        stage("Build") {
            steps {
                sh "npm install"
                sh "npm run build"
            }
        }
        stage("deploy"){
            input{
                message "Ready to deploy"
                ok "Yes"
                parameters{
                    string(name: "SERVER", defaultValue: "server 1")
                    }
                }
            steps{
                sh './scripts/deploy.sh ${SERVER}'
                }
        }
    }
}