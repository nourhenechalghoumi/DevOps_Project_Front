pipeline {
    agent any

    tools {
        nodejs 'NodeInstaller'
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('ss')
    }

    stages {
        stage('Checkout GIT (Backend)') {
            steps {
                echo "Getting Project from Git (Backend)"
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/nourhenechalghoumi/DevOps_Project_Back.git']]])
            }
        }

        stage('Run Unit Tests JUNIT') {
            steps {
                sh 'mvn clean test'
            }
        }

        stage('Build and Test Backend') {
            steps {
                script {
                    try {
                        sh 'mvn clean install'
                    } catch (Exception e) {
                        currentBuild.result = 'FAILURE'
                        error("Build failed: ${e.message}")
                    }
                }
            }
        }

        stage('SonarQube analysis') {
            steps {
                script {
                    withSonarQubeEnv(installationName: 'DevopsProject') {
                        sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.7.0.1746:sonar -Dsonar.login=squ_99f5d2d701628c8aca0a7fcd807ff448b8387001'
                    }
                }
            }
        }

        stage('Login Docker') {
            steps {
                sh "echo \$DOCKERHUB_CREDENTIALS_PSW | docker login -u \$DOCKERHUB_CREDENTIALS_USR --password-stdin"
            }
        }

        stage('Build & Push Docker Image (Backend)') {
            steps {
                script {
                    def imageName = "nourhenechalghoumi/devops_project"
                    sh "docker build -t $imageName ."
                    sh "docker login -u $DOCKERHUB_CREDENTIALS_USR -p $DOCKERHUB_CREDENTIALS_PSW"
                    sh "docker push $imageName"
                }
            }
        }

        stage('Deploy Back/DB') {
            steps {
                script {
                    sh 'docker-compose -f docker-compose.yml up -d'
                }
            }
        }
         //stage('Checkout GIT (Frontend)') {
           // steps {
             //   echo "Getting Project from Git (Frontend)"
               // checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/nourhenechalghoumi/DevOps_Project_Front.git']]])

                // This is where you build the frontend, run tests, and perform other frontend-specific tasks
                // dir('DevOps_Project_Front') {
                   // script {
                     //   sh 'npm install'
                        
                   // }
               // }
           // }
       // }
          

         stage('Deploy to Nexus') {
           steps {
                     script {
                        sh 'mvn deploy'
                     }
               }
         }
         
        stage('Deploy Prometheus and Grafana') {
            steps {
                script {
                     sh 'docker-compose -f docker-compose-prometheus.yml -f docker-compose-grafana.yml up -d'
                }
            }
        }
    }
    
    post {
        success {
            script {
                def subject = "Jenkins Build Notification - Success"
                def body = "The Jenkins build for your project has completed successfully."

                emailext (
                    to: 'test.devops697@gmail.com',
                    subject: subject,
                    body: body,
                )
            }
        }
        failure {
            script {
                def subject = "Jenkins Build Notification - Failure"
                def body = "The Jenkins build for your project has failed. Please investigate and take appropriate action."

                emailext (
                    to: 'test.devops697@gmail.com',
                    subject: subject,
                    body: body,
                )
            }
        }
    }
}

