pipeline {
  agent any

  stages {
      stage('Build Artifact') {
            steps {
              sh "mvn clean package -DskipTests=true"
              archive 'target/*.jar' //so that they can be downloaded later
            }
        }
      stage('Unit Tests - JUnit and Jacoco') {
            steps {
              sh "mvn test"
            }
            post {
              always{
                junit 'target/surefire-reports/*.xml'
                jacoco execPattern: 'target/jacoco.exec'
              }
            }
        }
      
      stage('Mutation Tests - PIT') {
            steps {
              sh "mvn org.pitest:pitest-maven:mutationCoverage"
            }
            post {
              always{
                pitmutation mutationStatsFile: '**/target/pit-reports/**/mutations.xml'
              }
            }
        }

      stage('SonarQube Analysis') {
        steps{
         sh "mvn sonar:sonar \
         -Dsonar.projectKey=numeric-application \
         -Dsonar.host.url=http://ec2-3-109-117-199.ap-south-1.compute.amazonaws.com:9000 \
         -Dsonar.login=sqp_1c4300830cc761a658b1dfdc705d7f287c4be6b5"
        }
      }

      stage('Docker Build and Push')
      {
        steps {
          withDockerRegistry([credentialsId:"dockerhub",url:""]){
            sh 'printenv'
            sh 'docker build -t whaleal3rt/numeric-app:""$GIT_COMMIT"" .'
            sh 'docker push whaleal3rt/numeric-app:""$GIT_COMMIT""'
          }
        }
      }

      stage('Kubernetes Deployment - DEV'){
        steps{
          withKubeConfig([credentialsId: 'kubeconfig']){
            sh "sed -i 's#replace#whaleal3rt/numeric-app:${GIT_COMMIT}#g' k8s_deployment_service.yaml"
            sh "kubectl apply -f k8s_deployment_service.yaml"
          }
        }
      }
    }
}
