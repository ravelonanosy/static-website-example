pipeline {
    agent any
		 environment {     
                HEROKU_API_KEY= credentials('heroku_api_key')
                IMAGE_NAME= 'staticwebsite-img'
                IMAGE_TAG= 'latest'
                CONTAINER_NAME= 'staticwebsite-ctnr'
		            ENV_STAGING= 'static-website-staging'
		            ENV_PROD= 'static-website-production'
                 				 
     } 
         stages {
                stage('Build') {
                 steps {
					script {
                     
					 sh '''
					     echo 'build image'
					     docker build -t $IMAGE_NAME:$IMAGE_TAG .
               docker images
					 
					 '''
					}
                 }
                 }
                 stage('run container') {
					steps {	
						script {
				    
							sh '''
							echo  'run a container'
							docker run -d --name $CONTAINER_NAME -e PORT=80 -p 8090:80 $IMAGE_NAME:$IMAGE_TAG
							docker ps
							sleep 5
							
							'''
						}
				
					}
                 }
				 stage('test') {
					steps {
						script {
							
							sh '''
       						echo 'test appli URL'
							    curl http://172.17.0.1:80
							
							'''
						}
                 }
                 }
				 
				 stage('delete container') {
					steps {
						script {
							
							sh '''
							echo 'delete container'
							docker stop $CONTAINER_NAME
							docker rm $CONTAINER_NAME
							
							'''
						}
					}
                 }
				 
				 stage('push in staging and deploy') {
				    when {
						expression { GIT_BRANCH == 'origin/master' }			
				      }
                    steps {
						script {
                        
							sh '''
								echo 'execute appli on heroku staging'
								#apk --no-cache add npm
    						#npm install -g heroku
	    					npm i -g heroku@7.68.0
								heroku container:login
								heroku create $ENV_STAGING || echo "project already exist"
								heroku container:push -a $ENV_STAGING web
								heroku container:release -a $ENV_STAGING web	
								
							'''
						}
					}
                 }
                stage('push in PRODUCTION and deploy') {
				    when {
						expression { GIT_BRANCH == 'origin/production' }			
				      }
                    steps {
						script {
                        
							sh '''
								echo 'execute appli on heroku'
								#apk --no-cache add npm
    								#npm install -g heroku
	    							npm i -g heroku@7.68.0
								heroku container:login
								heroku create $ENV_PROD || echo "project already exist"
								heroku container:push -a $ENV_PROD web
								heroku container:release -a $ENV_PROD web	
								
							'''
						}
					}
                 } 
               
		 }
	 post {
       			success {
        			 slackSend (color: '#00FF00', message: "SUCCESSFUL: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
         		}
      			failure {
            			slackSend (color: '#FF0000', message: "FAILED: Job '${env.JOB_NAME} [${env.BUILD_NUMBER}]' (${env.BUILD_URL})")
		          }   
    		}
}
