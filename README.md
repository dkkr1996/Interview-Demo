# Interview-Demo
My journey to completing the task
•	After receiving the task, the first thing I did was create a wbs so that I could analyze the task easily and divide them into small achievable components.
•	As soon as the wbs was completed I then immediately created all the required accounts so that I won’t be distracted by them when I am actually working on the task.
•	I broke down the terraform requirement into 4 separate blocks and then I went about writing the code for each of them and integrating them together and use variables wherever possible so that later if required additional resources could be provisioned easily.
•	When the code was completed I then pushed the code to a github repository.
•	Now the only thing remaining was to create the pipeline so I logged into my azure devops account and started creating the pipeline. I took github repository as the source for my data and then copied that to a container and then published the build artifact so that I can use that to feed the data to my release part of the pipeline.
•	I used a terraform assistant from the marketplace for this. Then I divided the this section into 3 separate task, one each for terraform init; terraform plan and terraform apply.
•	After feeding the task with all the required details like resource group and subscription, I then went on to create an additional powershell task which would come between the terraform plan and terraform apply.
•	This was a script which will check the terraform plan task and analyze if there are any changes made to the existing provisioned infrastructure.
•	If there are any changes made to the infrastructure then the terraform apply task will be notified and only then will that task be executed.
•	This will help save us a lot of time in the long run.
