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
        // Asegurarse de no mostrar el token en los logs
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
          // Construir la imagen Docker
          sh "docker build -t imagen_vulnerable ."
          
          // Ejecutar el escaneo con Snyk
          sh "snyk container test imagen_vulnerable"
        } catch (err) {

              echo err.getMessage()
            }
          }
        }
      }
    }
    
    stage('RunSnykSCA') {
      steps {
        withCredentials([string(credentialsId: 'SNYK_TOKEN', variable: 'SNYK_TOKEN')]) {
          sh "mvn snyk:test -fn"
        }
      }
    }



    stage('checkov') {
      steps {
        sh "checkov -s -f main.tf"
      }
    }
  }
}
