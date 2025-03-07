pipeline {
  agent any
  tools {
    maven 'Maven_3_8_7'
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
