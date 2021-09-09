# Vray command line options

```text
Usage:
  vray -server
or
  vray <option> <option> ...

where option (case-sensitive) is one of the following:
([] means optional string, {} means the string can be repeated
zero or more times)

SYSTEM OPTIONS:

    -help - print this help text and exit.

    -version - print the V-Ray version and exit.

    -credits - print copyright notices for V-Ray and available plugins.

    -configFile - the path and file name to the vray config file
         Note that additional paths for V-Ray plugins can also be specified
         with the VRAY_PLUGINS environment variable.
         (default is vrayconfig.xml in the same folder as vray.exe).

    -numThreads=nnn - set the number of rendering threads
         (default is 0 - automatic)

INPUT FILES:

    -sceneFile="filename.vrscene" - the scene file to render.

    -include="includePath{;includePath}" - specify path(s) for include files.
         More than one -include options can be specified.

    -remapPath="fromPath=toPath{;fromPath=toPath}" - specify path remapping pair.
         More than one -remapPath options can be specified.

    -remapPathFile="remapFile.xml" - specify path to an XML file with
         path remapping data.
         Example file:

         <RemapPaths>
             <RemapItem>
                 <From>Z:/export</From>
                 <To>/mnt/export</To>
             </RemapItem>
         </RemapPaths>

    -parameterOverride="<plugin-parameter-id>=<value>" - make it possible to
         change values for plugin parameters without editing the vrscene file.
         <plugin-parameter-id> - can be two formats - PluginType::parameterName
         or pluginName.parameterName.
         <value> - its format depends on the type of the parameter you want to
         override. Supported types are bool, int, float, color, acolor, texture
         and float texture. For bool, int and float a simple number is expected
         For color - Color(1, 0.0, 1.0) is expected. For acolor - AColor(1.0, 0,
         0, 0.3). For texture the format should be the same as for acolor or the
         name of a plugin to connect to the parameter. For float texture
         parameters either one float or a name of a plugin is expected.
         More than one -parameterOverride options can be specified and they will
         be executed in the order they are specified on the command line.
         Examples:
            -parameterOverride="SettingsImageSampler::type=3"
            -parameterOverride="TexFresnel::fresnel_ior=1.3"
            -parameterOverride="VRayMtl1@diffuse.color=Color(1.0,0.2,1.0)"
            -parameterOverride="VRayMtl2@diffuse.color_tex=checker1"

    -camera="<sceneName>" - specify which camera should be used for rendering.
         The name should correspond to the camera settings scene_name param.

RENDER OUTPUT:

    -imgFile="fileName" - write the resulting image to the given file.
         If the file name is empty, no image will be written.

    -imgWidth=nnn - set the output image width.
         (default is 640 or as specified in the .vrscene file)

    -imgHeight=nnn - set the output image height.
         (default is 480 or as specified in the .vrscene file)

    -region=x0;y0;x1;y1 - set the region to render.
         The integer values are in pixels, relative to the upper-left corner
         of the image.
         (default is full image or as specified in the .vrscene file)

    -region=none - ignore any the region specified in the .vrscene file

    -crop=x0;y0;x1;y1 - set the crop region to render.
         The integer values are in pixels, relative to the upper-left corner
         of the image.
         (default is full image or as specified in the .vrscene file)

    -frames=b0[-e0[,s0]]{;bn[-en[,sn]]} - specify the frames and/or frame
         intervals to render. More than one -frames option can be specified.
         bX is the start frame, eX is the end frame, and sX is the frame
         increment. If not specified, the frames from the scene description
         are rendered.

    -noFrameNumbers=0/1 - controls whether the -frames option will cause
         frame numbers to be automatically appended to the names of the
         rendered image files.
         (default is 0 - the -frames option always causes frame numbers to
         be added to the output image files.)


    -skipExistingFrames=0/1 - if there is an output file for the current frame,
         then the frame will be skipped and next one (if any) will be started.
         (default is 0 - no frame skipping)

    -resume=0/1 - if there is a resumable file existing for the current frame,
         the rendering will be resumed from it. Otherwise a new render will be
         started and resumable files will be saved. If the rendering is already
         complete, the frame will be skipped and the next one (if any)
         will be started.
         Render resuming with bucket sampling works with raw .vrimg files.
         Other formats are supported by saving a separate .vrimg file with
         the same name as the output image. Deep output and tiled EXR files
         are currently not supported.
         Resuming with progressive sampling works by saving a separate
         progressive resumable file (.vrprog) with the same name as the
         output image.
         (default is 0 - do not resume)

    -progressiveAutoSave=fff - autosave resumable file every fff minutes
         during progressive rendering, fff is a floating-point number.
         Resuming must be enabled for this to have any effect.
         (default is 0.0 - autosave disabled)

VFB DISPLAY OPTIONS:

    -display=0/1 - show the rendered image in a window
         (default is 1 - show the rendered image)

    -autoClose=0/1 - automatically closes the displayed image when rendering
         is complete
         (default is 0 - wait for user to close the VFB).

    -setfocus=0/1 - set the focus on the VFB window if displayed.
         (default is 1 - set the focus)

    -displaySRGB=0/1/2 - determines if the sRGB option of the V-Ray VFB will be
         turned on or off initially: 0 - use sRGB state from the VFB settings
         plugin in the scene file (defaults to on); 1 - sRGB is on;
         2 - sRGB is off.
         This can also be specified with the VRAY_VFB_SRGB environment variable.
         The command line option overrides the environment variable.
         (default is 0)

    -displayLUT=0/1 - determines if the LUT option of the V-Ray VFB will be
         turned on or off initially. This can also be specified with the
         VRAY_VFB_LUT environment variable. The command line option overrides
         the environment variable. The LUT file itself can be specified with
         the VRAY_VFB_LUT_FILE environment variable.
         (default is 0 - LUT is off)

    -displayOCIO=0/1 - determines if the OCIO option of the V-Ray VFB will be
         turned on or off initially. This can also be specified with the
         VRAY_VFB_OCIO environment variable. The command line option overrides
         the environment variable. The OCIO configuration itself can be
         specified with the OCIO environment variable.
         (default is 0 - OCIO is off)

    -displayAspect=0/1 - determines if the pixel aspect option of the V-Ray VFB
         will be turned on or off initially. This can also be specified with
         the VRAY_VFB_PIXEL_ASPECT environment variable. The command line
         option overrides the environment variable.
         (default is 0 - pixel aspect is off)

CONSOLE OUTPUT:

    -verboseLevel=n - specifies the verbose level of information printed
         to the standard output: 0 - no information printed; 1 - only errors;
         2 - errors and warnings; 3 - errors, warnings and informational
         messages; 4 - all output
         (default is 3)

    -detailedTiming=0/1 - specifies whether summary timing information would
         be printed to the standard output at the end of execution. 0 - disable;
         1 - enable;
         (default is 0)

    -showProgress=n - specifies whether calculations progress should be
         printed to the standard output: 0 - do not display progress;
         1 - display progress only if verboseLevel is > 0; 2 - always.
         (default is 1)

    -progressUpdateFreq=n - specifies the progress update frequency in ms.
         Only one of -progressUpdateFreq and -progressIncrement is used,
         depending on which is specified last on the command line.
         (default is 200ms)

    -progressIncrement=n - specifies the progress increment in percentage.
         Only one of -progressUpdateFreq and -progressIncrement is used,
         depending on which is specified last on the command line.

    -progressUseCR=0/1 - controls how to use carriage return when outputting
         render progress. 0 uses regular \n line endings and is useful when
         redirecting the output to a file; 1 uses \r to save screen space.
         (default is 1)

    -progressUseColor=0/1 - specifies whether to colorize the output:
         1 - enable, 0 - disable
         (default is 1)

RT ENGINE:

    -rtEngine=0/1/3/5/7 - renders with the RT engine instead of the regular
         V-Ray renderer: 0 - use the regular V-Ray renderer (no RT engine);
         1 - use the CPU version of the RT engine; 3 - use the OpenCL version
         of the RT engine; 5 - use the CUDA version of the RT engine; 7 - use
         the RTX version of the RT engine.
         (default is 0 - use the regular V-Ray renderer)

    -rtTimeOut=fff - specifies a timeout value for a frame when using the RT
         engine. fff is a floating-point number representing time in minutes.
         (default is 0.0 - no timeout)

    -rtNoise=fff - specifies noise threshold for a frame when using the RT
         engine. fff is a floating-point number.
         (default is 0.001)

    -rtSampleLevel=N - specifies maximum paths per pixel when using the RT
         engine. N is an integer number.
         (default is 0 - no limit)

DISTRIBUTED RENDERING:

    -server - Start in server mode waiting for connections.

    -distributed=0/1/2 - specifies whether to use distributed rendering:
         0 - do not use distributed rendering; 1 - use distributed rendering
         including the local machine; 2 - use distributed rendering excluding
         the local machine.
         (default is 0 - no distributed rendering)

    -renderhost="host{;host}" - use these host(s) for distributed rendering.
         Hosts can be specified either as computer names or by IPs. More than
         one -renderhost options can be specified.

    -portNumber=n - specify the port number to use for distributed rendering.
         The port numbers of the render servers and the render client must
         match for DR to work. The port can also be overridden using the
         VRAY_DR_CONTROLPORT environment variable. This command line option
         overrides the environment variable.
         (default is 20207)

    -transferAssets=0/1/2 - specifies whether missing assets should be
         transferred to the DR servers: 0 - do not transfer; 1 - transfer
         missing assets; 2 - check for assets in the asset cache folder before
         transferring them. The VRAY_ASSETS_CACHE_PATH environment variable can
         be used to specify the asset cache folder; if it is not specified,
         the assets are stored in a directory "vray_assets_cache" inside the
         temp folder for the current user.
         (default is 0 - do not transfer assets)

    -cachedAssetsLimitType=0/1/2 -  type of limitation used for cached assets
         on DR server: 0 - no limits; 1 - older than, assets older than 
         specified period of hours will be deleted. 2 - cache size, if the 
         assets cache grow over the specified size (GBs), the oldest assets
         will be deleted from cache.
         (default is 0 - no limits)

    -cachedAssetsLimitValue=fff - specifies limit value for a cached assets.
         fff is a floating-point number representing the value. Meaning of the
         value depend of -cachedAssetsLimitType parameter.
         (default is 0.0)

    -overwriteLocalCacheSettings=0/1 - specifies which settings for asset cache
         limitations to be taken into account. 0 - server's settings.
         1 - client's settings.
         (default is 0 - use server's settings for assets cache limitations)

    -limitHosts=N - limit the number of render hosts used for distributed
         rendering to the first N idle hosts specified in the -renderHost
         options.
         (default is 0 - use all available hosts)

     -autoCloseIfIdle=n - specify the minutes the server will wait in idle
         state before closing itself. A value of 0 means this feature is
         disabled otherwise it is the idle time in minutes.
```


