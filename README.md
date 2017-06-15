# RedHat OpenShift Container Platform

## INTRODUCTION

This guide will demonstrate,

* How to create a new project in OpenShift
* Launch your first application
* Learn how to trigger new builds/images when you make your first Github commit

## RESOURCES

   * [OpenShift Blog](http://www.opencontrail.org/red-hat-openshift-container-platform-with-opencontrail-networking/)
   
   * [OpenShift-Contrail Demo](https://www.youtube.com/watch?v=_vdwY1ux_gg)

## TRY IT OUT

* [Sign up](https://manage.openshift.com/) for OpenShift online

* [Sign up](https://github.com) for a GitHub account if you don't have one

* Login to OpenShift online<br /><br />Click **Open Web Console**
<br /><br />![Web Console](https://github.com/savithruml/openshift-contrail/blob/master/images/login-to-console.png)

* Click **New Project** 
<br /><br />![New Project](https://github.com/savithruml/openshift-contrail/blob/master/images/new-project.png)

* Provide a unique _name, display name_<br /><br />Click **Create**
<br /><br />![Project Info](https://github.com/savithruml/openshift-contrail/blob/master/images/project-info.png)

* Click on **Add to Project**<br /><br />Select **Python** under _Browse Catalog_<br /><br />Select **Django + PostgreSQL (Persistent)**
<br /><br />![Add to project](https://github.com/savithruml/openshift-contrail/blob/master/images/catalog.png)
<br /><br />![Python Django](https://github.com/savithruml/openshift-contrail/blob/master/images/python-django-1.png)

* Login to Github<br /><br />Fork `https://github.com/openshift/django-ex`<br /><br />You must now have your own **django-ex** repository (`https://github.com/<your-github-username>/django-ex`)

* Copy the **URL** `https://github.com/<your-github-username>/django-ex` & go back to OpenShift UI

* In the window **My-Project > Add to Project > Catalog > Django + PostgreSQL (Persistent)** add your Github **URL** to the **Git Repository URL** field<br /><br />Click **Create**
<br /><br />![GitHub URL](https://github.com/savithruml/openshift-contrail/blob/master/images/python-django-2.png)

* In the next window, you will be given instructions to download the OpenShift client & also to create your first project. There is also a **URL** under **Making code changes** block<br /><br />Save this **URL**
<br /><br />![Continue](https://github.com/savithruml/openshift-contrail/blob/master/images/launch-app.png)

* Go to `https://github.com/<your-github-username>/django-ex/settings/hooks`<br /><br />Paste the **URL** you saved from the previous step into the **Payload URL** field<br />Change **Content-type** to **application/json**<br /><br />Click **Add Webhook**
<br /><br />![Webhook-1](https://github.com/savithruml/openshift-contrail/blob/master/images/webhook.png)
<br /><br />![Webhook-2](https://github.com/savithruml/openshift-contrail/blob/master/images/webhooks-2.png)

* A build should've been started by now. After the build has completed, you will find a **URL** in the **Overview** tab in OpenShift UI<br /><br />Clicking the **URL** should open your **django web application**
<br /><br />![Build-app](https://github.com/savithruml/openshift-contrail/blob/master/images/deploy-1.png)
<br /><br />![app-live](https://github.com/savithruml/openshift-contrail/blob/master/images/app-live-1.png)

* Make some changes to the code, either in Github UI or on your local machine<br /><br />For example change the header in<br />`https://github.com/<your-github-username/django-ex/blob/master/welcome/templates/welcome/index.html` `line:214`<br /><br />**Commit** the change

      BEFORE:

             line 214: <h1>Welcome to your Django application on OpenShift</h1>

      AFTER:

             line 214: <h1>This is my 1st Django application on OpenShift</h1>


* This change should trigger a new build automatically<br /><br />Clicking on the **URL** should open the application, which is deployed with the changes you made
<br /><br />![Build-app-2](https://github.com/savithruml/openshift-contrail/blob/master/images/deploy-2.png)
<br /><br />![app-live-2](https://github.com/savithruml/openshift-contrail/blob/master/images/app-live-2.png)

    
