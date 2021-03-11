pipeline {
    agent any
    tools{
    maven 'maven 3'
    }

    stages {
        stage('Delete the Workspace') {
            steps {
                sh 'sudo rm -rf $WORKSPACE/*'
            }
        }
	 stage('Pull Source Code') {
            steps {
		git credentialsId: 'hp', url: 'git@github.com:rishikhuranasufi/tt-java.git'
            }
        }

        stage ('Build') {
            steps {
              sh '''
                  export M2_HOME=/usr/local/maven
                  export MAVEN_HOME=/usr/local/maven
                  export PATH=${M2_HOME}/bin:${PATH}
                  mvn -version
                  mvn clean install
              '''
            }
            post {
                success {
                    junit 'target/surefire-reports/**/*.xml'
                    stash(name: "tt-java-artifact", includes: 'target/*.jar')
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                }
            }
	    }
         stage('Deploy to staging') {
            steps {                
                unstash("tt-java-artifact")
                withCredentials([sshUserPrivateKey(credentialsId: 'python', keyFileVariable: 'privatefile', passphraseVariable: '', usernameVariable: 'username')]) {             
                        sh 'scp -i ${privatefile} ./target/*.jar ubuntu@3.12.104.242:~/app.jar'
			sh ' pwd'
			sh ' ls -lart'
			sh ' cat deploy.sh'
                        sh 'scp -i ${privatefile} deploy.sh ubuntu@3.12.104.242:/home/ubuntu/'
			sh 'ssh -i ${privatefile} ubuntu@3.12.104.242 bash /home/ubuntu/deploy.sh'
                        //sh 'screen -d -m ssh -i ${privatefile} ubuntu@3.12.104.242 java -jar ~/app.jar'
                    }
                }
            }
        }
    }    
