pipeline {
  agent any
  tools {
    maven 'Maven_3_8_7'
  }

  stages {
    stage('Compilar_y_SAST') {
      steps {
        withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
          script {
            sh """
              mvn -Dmaven.test.failure.ignore verify sonar:sonar -Dsonar.login=\$SONAR_TOKEN -Dsonar.projectKey=Jenkins-Pipeline -Dsonar.host.url=http://localhost:9000/
            """
          }
        }
      }
    }

    stage('Container_Scan') {
      steps {
        withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
          script {
            try {
              sh "docker build -t imagen_vulnerable ."
              sh "snyk container test imagen_vulnerable"
            } catch (err) {
              echo err.getMessage()
            }
          }
        }
      }
    }
    
    stage('SNYK_SCA') {
      steps {
        withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
          sh "mvn snyk:test -fn"
        }
      }
    }

    stage('Escaneo_Terraform_Trivy') {
      steps {
        sh "trivy config main.tf"
      }
    }

    stage('Deploy en Kubernetes') {
      steps {
        script {
          sh """
          kubectl apply -f - <<EOF
          apiVersion: apps/v1
          kind: Deployment
          metadata:
            name: mi-app
          spec:
            replicas: 1
            selector:
              matchLabels:
                app: mi-app
            template:
              metadata:
                labels:
                  app: mi-app
              spec:
                containers:
                - name: mi-app
                  image: imagen_vulnerable
                  ports:
                  - containerPort: 80
          ---
          apiVersion: v1
          kind: Service
          metadata:
            name: mi-app-service
          spec:
            selector:
              app: mi-app
            ports:
              - protocol: TCP
                port: 80
                targetPort: 80
            type: ClusterIP
          EOF
          """
        }
      }
    }
  }
}
