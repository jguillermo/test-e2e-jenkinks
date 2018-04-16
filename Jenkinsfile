pipeline {
  agent any
  parameters {
    booleanParam(
      name: 'REGISTRY',
      defaultValue: false,
      description: "Requiere construir o no Registry in ECR")
  }
  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }
    stage('Set Enviroment') {
      steps {
        script {
          
          if (fileExists("./deploy/parameters/${GIT_BRANCH}.yml")) {
            def configFile = readYaml file: "./deploy/parameters/${GIT_BRANCH}.yml"
            println "config ==> ${configFile}"
            for (var in configFile.environment) {
              env[var.key] = var.value
            }
            echo "${ENV}"
            echo "${DEPLOY_REGION}"
          }
          else {
            error("No existe la configuracion para la rama ${GIT_BRANCH}")
          }
        }
        
        
      }
    }
    stage('Registry') {
      steps {
        script {
          if ("${params.REGISTRY}" == "true") {
            sh 'make aws-create-registry'
          }
        }
      }
    }
    stage('Build images') {
      steps {
        sh 'make build'
      }
    }
    stage('Test') {
      steps {
        sh 'make test-restart'
      }
    }
    stage('Deploy') {
      steps {
        sh 'make aws-deploy'
      }
    }
  }
  post {
    always {
      sh '''
        make test-ps
        make test-down
        make test-ps
        '''
      cleanWs()
    }
    success {
      sh '''
        echo "FIN SUCCESS"
        '''
    }
    failure {
      sh '''
        echo "FIN ERROR"
        '''
    }
  }
}
