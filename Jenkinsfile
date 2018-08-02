#!/usr/bin/env groovy

pipeline {
  agent { label 'master' }

  environment {
    DEVELOPER_DIR = '/Xcode/9.4.1/Xcode.app/Contents/Developer'

    SLACK_COLOR_DANGER  = '#E01563'
    SLACK_COLOR_INFO    = '#6ECADC'
    SLACK_COLOR_WARNING = '#FFC300'
    SLACK_COLOR_GOOD    = '#3EB991'

    PROJECT_NAME = 'iOS CalWebView'
  }

  options {
    disableConcurrentBuilds()
    timestamps()
    buildDiscarder(logRotator(numToKeepStr: '10'))
    timeout(time: 75, unit: 'MINUTES')
  }

  stages {
    stage('Announce') {
      steps {
        slackSend (color: "${env.SLACK_COLOR_INFO}",
                  message: "${env.PROJECT_NAME} [${env.GIT_BRANCH}] #${env.BUILD_NUMBER} *Started* (<${env.BUILD_URL}|Open>)")
      }
    }
    stage('Update submodules') {
      steps {
        sh 'git submodule update --init --recursive'
      }
    }
    stage('Prepare') {
      environment {
        // TODO: pages are now on s3 and should be pulled from there
        IFRAME_SOURCE="CalWebViewApp/CalWebViewApp/iframe.html"
        PAGE_SOURCE="CalWebViewApp/CalWebViewApp/page.html"

        IFRAME_TARGET="/Library/Server/Web/Data/Sites/Default/CalWebViewApp/iframe.html"
        PAGE_TARGET="/Library/Server/Web/Data/Sites/Default/CalWebViewApp/page.html"
      }
      steps {
        sh '''
          cp "${IFRAME_SOURCE}" "${IFRAME_TARGET}"
          cp "${PAGE_SOURCE}" "${PAGE_TARGET}"
        '''
        sh '''
          gem update --system
          gem uninstall -Vax --force --no-abort-on-dependent calabash-cucumber
          gem uninstall -Vax --force --no-abort-on-dependent run_loop
        '''
        sh 'bundle update'
      }
    }
    stage('Clean') {
      steps {
        sh 'cd CalWebViewApp; make clean'
      }
    }
    stage('Run tests') {
      steps {
        sh 'bundle exec bin/ci/test-cloud.rb'
        sh 'bundle exec bin/ci/jenkins/cucumber.rb --tags ~@pending'
      }
    }
  }

  post {
    always {
      junit 'CalWebViewApp/reports/**/*.xml'
    }
    aborted {
      echo "Sending 'aborted' message to Slack"
      slackSend (color: "${env.SLACK_COLOR_WARNING}",
                message: "${env.PROJECT_NAME} [${env.GIT_BRANCH}] #${env.BUILD_NUMBER} *Aborted* after ${currentBuild.durationString.replace('and counting', '')}(<${env.BUILD_URL}|Open>)")
    }

    failure {
      echo "Sending 'failed' message to Slack"
      slackSend (color: "${env.SLACK_COLOR_DANGER}",
                message: "${env.PROJECT_NAME} [${env.GIT_BRANCH}] #${env.BUILD_NUMBER} *Failed* after ${currentBuild.durationString.replace('and counting', '')}(<${env.BUILD_URL}|Open>)")
    }

    success {
      echo "Sending 'success' message to Slack"
      slackSend (color: "${env.SLACK_COLOR_GOOD}",
                message: "${env.PROJECT_NAME} [${env.GIT_BRANCH}] #${env.BUILD_NUMBER} *Success* after ${currentBuild.durationString.replace('and counting', '')}(<${env.BUILD_URL}|Open>)")
    }
  }
}
