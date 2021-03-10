pipeline {
    agent any

    stages {
        stage('Delete the Workspace') {
            steps {
                sh 'sudo rm -rf $WORKSPACE/*'
            }
        }
	 stage('Pull Source Code') {
            steps {
		git credentialsId: 'hp', url: 'git@bitbucket.org:technotrainer-mod-dev/java-project.git'
            }
        }
        stage ('Initialize') {
            steps {
                sh '''
                    cd /usr/local
                    sudo wget https://www-eu.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
                    sudo tar xzf apache-maven-3.6.3-bin.tar.gz
                    sudo ln -sf apache-maven-3.6.3 maven                    
                '''
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
                        sh 'scp -i ${privatefile} ./target/*.jar ubuntu@3.12.104.242:~/app1.jar'
                        //sh 'export BUILD_ID=dontKillMe'
                        sh 'ssh -i ${privatefile} ubuntu@3.12.104.242 export JENKINS_NODE_COOKIE=dontKillMe nohup java -jar ~/app1.jar >> ~/applogs.log 2>&1 &'
                        //sh 'screen -d -m ssh -i ${privatefile} ubuntu@3.12.104.242 java -jar ~/app1.jar'
                    }
                }
            }
        }
    }    
