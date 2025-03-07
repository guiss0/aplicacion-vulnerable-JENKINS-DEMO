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
        // Asegurarse de no mostrar el token en los logs ESCAPANDO EL SECRETO CON \
        sh """
            mvn clean verify sonar:sonar \
            -Dsonar.projectKey=Jenkins-Pipeline \
            -Dsonar.projectName='Jenkins-Pipeline' \
            -Dsonar.host.url=http://localhost:9000 \
            -Dsonar.token=${SONAR_TOKEN}

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
          // Construir la imagen Docker
          sh "docker build -t imagen_vulnerable ."
              // deployear la pagina web vulnerable
          sh "kubectl apply -f deployment.yaml"
              // por forwarding al puerto 80 la aplicacion web 
          sh "kubectl port-forward deployment/imagen_vulnerable 80:80"
              
          // Ejecutar el escaneo con Snyk
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
  }
}
