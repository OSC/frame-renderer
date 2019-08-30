# OpenOndemand Frame Renderer

[User Guide](#User-Guide)

[Installer Guide](#Installer-Guide)

## Description

This is an [Open OnDemand](https://openondemand.org) application for rendering animation frames. 
It currently supports [AutoDesk's Maya](https://www.autodesk.com/products/maya/overview) as it's 
rendering engine. 

# User Guide

## Creating a new project

### Upload your project

#### Using the File Explorer

First you need to upload your project to the cluster if the files are not already there.
An easy way may be the File application provided by OnDemand. In it you can simply drag
and drop a directory if it's less than 10 GB.

You'll want to upload it to your `$HOME/maya/projects` directory. In this example `$HOME` is 
`/home/jeff` and it will change depending on the site and your username.  You may have to 
make this directory, and how to do that is also highlighted in this picture in the upper right.

![drag_and_drop](/docs/imgs/dragging_dropping.PNG)

#### Using an SFTP Client

If you're using [WinSCP](https://winscp.net/eng/index.php), here are is a basic tutorial on how to 
connect to your site. 

Create a new connection like I have here. `scp.osc.edu` is OSC's ftp server, your site's hostname
will differ if you don't use OSC. You'll have to specify your own username & password in the
appropriate fileds fields.

![sftp](/docs/imgs/sftp_config.PNG)

Open this connection up and navigate to `$HOME/maya/projects`. In this example `$HOME` is 
is`/users/PZS0714/johrstrom`. Again, you may have to make the sub-directories, but the buttons
are shown.

Once you're connected, you can simply drag and drop folders back and forth.

![sftp_navigate](/docs/imgs/sftp_navigate.PNG)

## Create a new project

Click the ![new_project](/docs/imgs/new_project_button.PNG) button to create a new project. 

There you'll need to give it a name an optionally a description.  You'll also need to specify 
where this project directory is. It should be the location of the files you just uploaded.
Use the file picker ![project_file_picker](/docs/imgs/project_dir_select.PNG) to help choose 
this directory. Press ![save_project](/docs/imgs/project_create.PNG) and you're ready to 
get started.


## Creating a new submission

A submission is essentially a preset of arguements you want to execute a job with. Logically, it's 
something like *I want to render the first 10 frames of this scene and get an email when it's done*. 

To create a new submission simply press the ![new_submission](/docs/imgs/new_submission.PNG)
button. Fill out all the nessecary form items and 

|Option|Description|Example|
|:----------------:|:-----------------:|:-----------------:|
|name|The name of the submission.|always render first 10|
|frames|The frames you want to render.|1-10|
|frames|The camera view you want to render.|camera1|
|frames|The ma or mb file you want to render.|/home/me/maya/projects/project_1/scenes/testScene1.ma|
|cluster|The cluster you want to submit to.|owens|OSC can only submit to owens at this time|
|renderer|The rendering engine you want to use.|arnold|
|extra|Extra arguements you want to give to the command. See more [here](#Extra-arguements).|-verb -b 1 -ai:lve 0|
|scheduled hrs|The amount of time in hours your job will be scheduled.|3|
|email|A choice to email you when the job is complete.|(checked)|
|skip existing|A choice for the renderer to skip rendered images if they already exist.|(not checked)|

Press ![save](/docs/imgs/save.PNG) and you're all done.

### Editing and Deleting

Once you've created a submission you can always go back and edit it through the ![edit](/docs/imgs/edit.PNG) button. 

And, for whatever reason, you decide you don't want it anymore simply press the ![edit](/docs/imgs/delete.PNG) button
to delete it.

## Submitting jobs and finding the output

Now that you have a job submission all configured you're ready to submit a job. Simply press the 
 ![submit](/docs/imgs/submit.PNG) button. 

You should see a submision similar to this one below

![not_submitted](/docs/imgs/not_submitted.PNG)

turn it's status ![queued](/docs/imgs/queued.PNG), get a job id, and finally running like this job that's
running:

![running](/docs/imgs/running.PNG)

Note how the  ![submit](/docs/imgs/submit.PNG) and ![stop](/docs/imgs/stop.PNG) buttons toggle functionality depending
on if the job is currently running or not.  Now that the job is running, you may not submit a new job and you may stop
the current job.  Once it is complete, then you may not stop it (becuase you can't) and you may submit a new job.

In this example `7707372.owens-batch.ten.osc.edu` is the job id and we can view it's output under the project's `batch_jobs` directory. 

There will now be a `batch_jobs/7707372.owens-batch.ten.osc.edu/7707372.owens-batch.ten.osc.edu.out` output file which is the log for
this job. If you're having issues rendering files, look at these log files for errors.

Specifically near the bottom, where you should see messages like this.  If you need to increase the log level, see [below](#Extra-arguements)
on how to do that.
```bash
Scene /users/PZS0714/johrstrom/maya/projects/MasterProject/scenes/kai_turntable_02.mb completed.
// Maya exited with status 0
ended at Fri Aug 30 10:00:16 EDT 2019
ended with status 0
```

## Exit status' from Torque

At [OSC](https://www.osc.edu/) we run Torque so commonly seen exit status' are documented here
for convenience. 

|Exit status|Description & Cause|
|:----------------:|:-----------------:|
|0|This is the **only** good exit status. This means everything went OK, from the jobs' perspective. <br> Maya still could have 'successfully done the wrong thing'.|
|-11|The job was killed because it ran out of time. Increase the walltime to avoid this. |
|211|Maya cannot read your scene file properly. It's either corrupt, or it was never real. <br> Regenerate this scene file in the Maya UI.|
|271|The job was killed by a user.|

## Extra arguements

The default given is `-verb -b 1 -ai:lve 0`.  Here's a breakdown of what those flags mean:

* `-verb` Print Mel commands before they are executed
* `-b 1` By frame (or step) for an animation sequence
* `-ai:lve 0` Verbosity level. (0 - Errors, 1 - Warnings + Info, 2 - Debug)

So if you wanted to say, render every 3 frames you would use `-b 3` instead of `-b 1`.  Or if you 
wanted to turn turn up your log level you could use `-ai:lve 1` or even 2.  

Note that you can use any combination of arguements.  You can remove some or add some independently
of each other.  

To view all of the possible arguements see [this page](/docs/mds/ARNOLD.md) for the Arnold renderer. Flags for 
other renderers are not documented here, but could be if requested.

## Running Maya UI in a VDI

It's possible for users to run the AutoDesk Maya UI through a virtual deskop application in OpenOndemand (VDI). 
Users can follow [this gist](https://gist.github.com/johrstrom/110242c274eea508110477dc150d26a5) for directions on how to 
create a desktop icon. 

# Installer Guide

## Install the RPM

TODO: setup RPM packaging and describe instructions here.

## Custom Initializers

Create the file `/etc/ood/config/apps/frame-renderer/initializers/site_cluster_overrides.rb` and populate it 
with the ruby class definition below. Notes are given as to why you're overriding these methods.

```ruby
class Submission

  # change the default cluster
  def default_cluster  
    'my sites default cluster'
  end

  # ensure users can't submit to some cluster. For example OSC cannot submit 
  # to 'ruby' or 'pitzer' becuase they don't have the required maya libraries.
  # This method may be empty.
  def cluster_ok?
    raise ArgumentError, cluster_error_msg('ruby') if cluster == 'ruby'
    raise ArgumentError, cluster_error_msg('pitzer') if cluster == 'pitzer'
  end

  # specify how many cores you want to allocate. Note you may have an if/esle
  # block here if you are able to submit to multiple clusters and they can use 
  # a different amount of cores.
  def cores
    28
  end

end
```

Just to be clear, this is `cluster_error_msg` in case administrators want to use it 
or even override it.
```ruby
  def cluster_error_msg(cluster)
    "Cannot execute Maya Jobs on #{cluster}, must choose #{default_cluster}"
  end
```

# Developer Guide

Note, you'll need [development eneabled](https://osc.github.io/ood-documentation/master/app-development.html)
in your ondemand installation for you to develop applications.  Or you can check out our 
[images](https://github.com/OSC/ood-images) to develop against.

<br>

First clone this repo.
`scl enable rh-git29 -- git clone https://github.com/OSC/frame-renderer.git frame-renderer`

Run `scl enable rh-ruby24 -- bin/setup` to setup everything up.

Then run `scl enable rh-ruby24 -- rake db:migrate` to migrate your database.

Now you should be able to connect to `<your server>/pun/dev/frame-renderer`.

