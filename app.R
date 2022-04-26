require(shiny)
require(DBI)
require(RPostgreSQL)
require(shinyMobile)
library(shinyTime)
source("connectKennedy.R")

con = connectKennedy()
KTFquery = function(stat, query=FALSE)
{
  if (query) dbGetQuery(con, statement = stat)
  else fetch(dbSendQuery(con, statement = stat), n=-1)
}


ui=f7Page(title="KTFapp", allowPWA=TRUE,
          f7SingleLayout(
            navbar = f7Navbar(
             title= "Kennedy Tree Farm fishing app",
             hairline=FALSE,
             shadow=TRUE
            ),
f7Text("name", "What is your name?"),
f7DatePicker("date", "Date",dateFormat = "yyyymmdd"),
numericInput("effort", "How much time have you spent fishing today (in hours)", value=NULL),
             f7Radio("lake", "Select a lake",
                choices = list("Big Lake", "Small Pond", "Nursery", "Hidden")),
f7Radio("species", "Species caught",
               choices = list(
                 "Bluegill", "Largemouth Bass", "Black Crappie",
                 "Channel Catfish", "Chain Pickerel", "Muskie",
                 "Other")),
numericInput("length", label="Length (cm)", value=NULL),
numericInput("weight", label="Weight (g)", value=NULL),
f7Text("tag", "Tag ID"),
f7Text("lure", "Bait/Lure used"),
timeInput("time", "Time of day (set to current time)", value = Sys.time(), seconds=FALSE),
f7Text("target", "What was your target species?"),
f7Text("notes", "Comments"),
fileInput("myFile","Submit an image" ,accept = c('image/png', 'image/jpeg')),
uiOutput("image"),
    actionButton("submit", "Submit")
)
)
server = function(input,output,session){
  

  
  observeEvent(input$submit, {
    observeEvent(input$myFile, {
      inFile <- input$myFile
      if (is.null(inFile))
        return()
      file.copy(inFile$datapath, file.path("www/", inFile$name) )
    
    date_tagged=input$date
    lake=input$lake
    angler=input$name
    time=print(strftime(input$time, "%R"))
    common=input$species
    target_species=input$target
    if (is.na(input$length)) length_cm='NULL' else length_cm=input$length
    if (is.na(input$weight)) weight_g='NULL' else weight_g=input$length
    tagid=input$tag
    bait_lure=input$lure
    if (is.na(input$effort)) time_targeted='NULL' else time_targeted=input$effort
    notes=input$notes
    statement=paste("INSERT into fishdat (date_tagged,lake,angler,time,common,target_species,length_cm,
                    weight_g,tagid,bait_lure,time_targeted,notes,image) values 
                    ('",date_tagged,"','",lake,"','",angler,"','",time,"','",
                    common,"','",target_species,"',",length_cm,",",weight_g,",'",
                    tagid,"','",bait_lure,"',",time_targeted,",'",
                    notes,"','",inFile$name,"');", sep="")
    # c=data.frame(stat = statement)
    # write.csv(c, "/mnt/e/Dropbox/KTFapp/test.csv", row.names = F)
    KTFquery(stat=statement, query=TRUE)
    session$reload()
    })
  })
  
  
  
}


shinyApp(ui = ui, server = server)