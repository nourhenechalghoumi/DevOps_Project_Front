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

        stage('Checkout GIT (Frontend)') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/nourhenechalghoumi/DevOps_Project_Front.git']]])
            }
        }

      //  stage('Build Frontend') {
        //    steps {
          //      script {
            //        echo "Getting Project from Git (Frontend)"
              //      sh 'npm install'
                //    sh 'ng build'
               // }
           // }
       // }
     

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
                    sh "docker login -u $DOCKERHUB_CREDENTIALS_USR -p \$DOCKERHUB_CREDENTIALS_PSW"
                    sh "docker push $imageName"
                }
            }
        }
        

        //stage('Build Docker Image (Frontend)') {
          //  steps {
            //    script {
              //      def imageName = "nourhenechalghoumi/devops_project_frontend"
                //    sh "docker build -t $imageName ."
                  //  sh "docker push $imageName"
               // }
           // }
       // }
       // stage('Debug') {
    	 //   steps {
        //	script {
          //  	    echo "Current PATH: ${env.PATH}"
            //        sh "npm list -g --depth=0"
        //	}
    	  //  }
//	}


        stage('Deploy Front/Back/DB') {
            steps {
                script {
                    sh 'docker-compose -f docker-compose.yml up -d'
                }
            }
        }
    }

    post {
        success {
            script {
                def subject = "Notification success"
                def body = "BUILD DONE "
                def to = 'test.devops697@gmail.com'

                mail(
                    subject: subject,
                    body: body,
                    to: to,
                )
            }
        }
        failure {
            script {
                def subject = "Build Failure - ${currentBuild.fullDisplayName}"
                def body = "The build has failed in the Jenkins pipeline. Please investigate and take appropriate action."
                def to = 'test.devops697@gmail.com'

                mail(
                    subject: subject,
                    body: body,
                    to: to,
                )
            }
        }
    }
}

