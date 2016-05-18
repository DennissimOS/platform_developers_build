<#--
 Copyright 2014 The Android Open Source Project

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->
buildscript {
    repositories {
        jcenter()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:2.1.0'
    }
}

apply plugin: 'com.android.application'

<#if sample.repository?has_content>
repositories {
<#list sample.repository as rep>
    ${rep}
</#list>
}</#if>

dependencies {

<#list sample.dependency_wearable as dep>
    <#-- Output dependency after checking if it is a play services depdency and
    needs the latest version number attached. -->
    <@update_play_services_dependency dep="${dep}" />
</#list>

<#list sample.provided_dependency_wearable as dep>
    provided "${dep}"
</#list>

    compile ${play_services_wearable_dependency}
    compile ${android_support_v13_dependency}
    compile ${wearable_support_dependency}
}

// The sample build uses multiple directories to
// keep boilerplate and common code separate from
// the main sample code.
List<String> dirs = [
    'main',     // main sample code; look here for the interesting stuff.
    'common',   // components that are reused by multiple samples
    'template'] // boilerplate code that is generated by the sample template process

android {
    compileSdkVersion ${compile_sdk}

    buildToolsVersion ${build_tools_version}

    defaultConfig {
        versionCode 1
        versionName "1.0"


      <#if sample.minSdkVersionWear?? && sample.minSdkVersionWear?has_content>
        minSdkVersion ${sample.minSdkVersionWear}
      <#else>
        minSdkVersion ${min_sdk}
      </#if>




      <#if sample.targetSdkVersionWear?? && sample.targetSdkVersionWear?has_content>
        targetSdkVersion ${sample.targetSdkVersionWear}
      <#else>
        targetSdkVersion ${compile_sdk}
      </#if>
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_7
        targetCompatibility JavaVersion.VERSION_1_7
    }

    sourceSets {
        main {
            dirs.each { dir ->
<#noparse>
                java.srcDirs "src/${dir}/java"
                res.srcDirs "src/${dir}/res"
</#noparse>
            }
        }
        androidTest.setRoot('tests')
        androidTest.java.srcDirs = ['tests/src']

<#if sample.defaultConfig?has_content>
        defaultConfig {
        ${sample.defaultConfig}
        }
<#else>
</#if>
    }
}
