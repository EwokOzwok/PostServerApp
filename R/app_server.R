#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinyMobile
#' @import shinyjs
#' @import future
#' @import promises
#' @import httr
#' @import jsonlite
#' @noRd
app_server <- function(input, output, session) {

  future::plan(multisession)

# Login UI ----------------------------------------------------------------

  output$Login_UI <- renderUI({
    tagList(
      f7Text(inputId = "username", label = "Username", value = NULL, placeholder = "Enter your username"),
      br(),
      f7Password(inputId = "password", label = "Password", value = NULL, placeholder = "Enter your password"),
      br(),
      hr(),
      f7Button(inputId = "login_btn", label = "Login")
    )
  })

# Create Reactive Variables -----------------------------------------------

  User_Role = reactiveVal(NULL)
  User_Username = reactiveVal(NULL)
  User_Password =  reactiveVal(NULL)


# Login Validation  -------------------------------------------------------


  observeEvent(input$login_btn, {
    req(input$username)
    req(input$password)

    if(input$username %in% login_data$Username){

      User_Role(login_data[login_data$Username == input$username, "Role"])
      User_Username(login_data[login_data$Username == input$username, "Username"])
      User_Password(login_data[login_data$Username == input$username, "Password"])

    } else {

      f7Notif(
        "Invalid Username or Password",
        icon = f7Icon("bolt"),
        title = "Error Notification",
        titleRightText = "now",
        subtitle = "Login Error",
        closeTimeout = 5000,
        closeOnClick = T,
        swipeToClose = T
      )

      return()

    }


  if(input$password == User_Password()){

    f7Notif(
      "Logging you in now...",
      icon = f7Icon("bolt"),
      title = "Notification",
      titleRightText = "now",
      subtitle = "Login Successful",
      closeTimeout = 5000,
      closeOnClick = T,
      swipeToClose = T
    )


    delay(2500,{
      updateF7Tabs("tabs", selected = "UserTab", session)
    })


  } else {

    f7Notif(
      "Invalid Username or Password",
      icon = f7Icon("bolt"),
      title = "Error Notification",
      titleRightText = "now",
      subtitle = "Login Error",
      closeTimeout = 5000,
      closeOnClick = T,
      swipeToClose = T
    )

    return()

  }

  })




# Post Request for Data Pull ----------------------------------------------

observeEvent(input$request_btn,{
  req(input$request)

  post_request_data <- list(
    request = input$request
  )


  response <- POST(
    "http://localhost:4499/post_request",
    body = toJSON(post_request_data, auto_unbox = T),
    encode = "json",
    content_type_json()
  )



  # Check for response
  result <- content(response, "parsed")
  if(response$status_code == 200){
    print(result$status)

    output_data <- result$output_data
    print(result$output_data)

    output_data <- as.character(output_data[1])

    output$Requested_Data <- renderUI({
      tagList(
        f7Align(h1("Requested Data"), side = c("center")),
        hr(),
        f7Align(h2(output_data), side = c("center")),


      )
    })

  } else {

    print(paste("Error:", result$status))

  }




})













}
