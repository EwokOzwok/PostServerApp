#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinyMobile
#' @import shinyjs
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    f7Page(
      title = "Post Request App",
      options = list(theme = c("auto"), dark = T, preloader = T, pullToRefresh = T),
      allowPWA = F,

      useShinyjs(),

      f7TabLayout(

        navbar = f7Navbar(title = "Post Request App"),

        f7Tabs(
          animated = T,
          id = "tabs",

          f7Tab(
            tabName = "LoginTab",
            icon = f7Icon("house_fill"),
            active = T,
            hidden = T,

            f7Block(
              f7Shadow(
                intensity = 5,
                hover = T,
                f7Card(
                  title = "Login",
                  uiOutput("Login_UI"),
                  hairlines = F, strong = T, inset = F, tablet = F
                ) # Close card
              )
            ) # close block
          ), # close Login tab

          f7Tab(
            tabName = "UserTab",
            icon = f7Icon("house_fill"),
            active = F,
            hidden = T,

            f7Block(
              f7Shadow(
                intensity = 5,
                hover = T,
                f7Card(
                  title = "Data Request",
                  f7Text("request", "Request Number", value = NULL, placeholder = "Enter your request number"),
                  br(),
                  hr(),
                  f7Button("request_btn", "Make Data Request"),
                  uiOutput("Requested_Data"),

                  hairlines = F, strong = T, inset = F, tablet = F
                ) # Close card
              )
            ) # close block


          )


        ) # close tabs

      ) # close tab layout



    ) # close page



  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "PostServerApp"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
