pipeline {
    
    tools {
        maven 'maven3'
        jdk 'jdk17'
    }
    enviroment {
        SCANNER_HOME = tool 'sonar-scanner'
    }
    stages {  
        stage('Compile') {
            steps {
               sh "mvn compile"
            }
        }
        
        stage('Test') {
            steps {
                sh "mvn test"
            }
        }
        stage('File system scan') {
            steps {
                sh "trivy fs --format table -o trivy-fs-report.html ." //scan repo
            }
        }  
        stage('SonarQube Analysis ') {
            steps {
                withSonarQubeEnv('sonar') {
                sh ''' $SCANNER_HOME/bin/sonar-scanner - sonar.projectName=BoardGame - Dsonar.projectKey=BoardGame \
                    -Dsonar.java.binaries=. '''
              }
            }
        }          
        stage('Quality Gate') {
            steps {
            script {
                waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
            }
        }
        }
        stage('Build') {
            steps {
                sh "mvn package"
            }
        }
        stage('Publish Artifact nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'global-settings' , jdk: 'jdk17' , maven: 'maven3', mavenSettingsConfig:'',traceability:true){
                    sh 'mvn deploy'
                }
            }
        }
        stage('Build & tag docker image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh 'docker build -t shadibadria/boardgame:latest .' //build
                }
            }
        }
        }
        stage('Docker Image Scan') {
            steps {
                sh "trivy image --format table -o trivy-image-report.html shadibadria/boardgame:latest" //scan repo
            }
        }  
        stage('Push Docker Image') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker-cred', toolName: 'docker') {
                        sh 'docker push shadibadria/boardgame:latest' //build
                }
            }
        }
        }
        stage('Deploy To K8') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://11.0.1.229:6443') {
                    sh 'kubectl apply -f deployment-service.yaml'
                } 
            }
        }
        stage('Verify Deployment') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'kubernetes', contextName: '', credentialsId: 'k8-cred', namespace: 'webapps', restrictKubeConfigAccess: false, serverUrl: 'https://11.0.1.229:6443') {
                    sh 'kubectl get pods -n webapps'
                    sh 'kubectl get svc -n webapps'
                } 
            }
        }
    }
}
