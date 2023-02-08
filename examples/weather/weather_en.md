[中文](weather.md) | [English](weather_en.md)

## weather assistant

Before we travel every day, we want to know the weather today? At this time, we can quickly create a weather query assistant based on the ability of PromptAI to help us query the weather.
### The following is the construction process

> 1. Click "Add Flow Chart" to create a flow chart named "Weather Query",  as shown in the figure:
>    ![weather_1.png](images/weather_1.png)

> 2. Select the Weather Query node, and the menu as shown in the figure will appear, as shown in the figure:
>    ![weather_2.png](images/weather_2.png)

> 3. Click the menu "User Input" to enter the editing node, as shown in the figure:
>    ![weather_3.png](images/weather_3.png)
>    Create a * * variable * * "city" to store the city to query the weather
     ![weather_4.png](images/weather_4.png)
>    Mark the city in the training example sentence
>    ![weather_5.png](images/weather_5.png)

> 4. Click "Project View" ->"Webhooks" to add "Webhooks", as shown in the figure:
>    ![weather_6.png](images/weather_6.png)
>    ![weather_7.png](images/weather_7.png)

> 5. Click "Project View" ->"Variable List" to add city-related hot words to the variable "city", as shown in the figure:
>    ![weather_8.png](images/weather_8.png)

> 6. Click "Debug Run - Current Module" in the upper right corner, wait for a period of time, and then try to talk, as shown in the figure:
>    ![weather_9.png](images/weather_9.png)

> 7. Click the "Publish Run" menu on the right to enter the publish deployment page, as shown in the figure:
>    ![weather_10.png](images/weather_10.png)

> 8. Click "Publish" in the upper right corner and wait for a period of time before you can talk, deploy scripts and preview online.
>    ![weather_11.png](images/weather_11.png)

> 9. Scan QR code and preview online
>     ![weather_12.png](images/weather_12.png)

### Successfully completed the construction

So far, we have successfully completed a weather query assistant robot, share it quickly!
