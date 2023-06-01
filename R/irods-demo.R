#' Run Docker iRODS demonstration service
#'
#' Run an iRODS demonstration server as an Docker container instance.
#' The functions `stop_irods_demo()` and `remove_docker_images()` are used to
#' stop the containers, and subsequently remove the images.
#'
#' These functions are untested on Windows and macOS and require:
#'  * `bash`
#'  * `docker`
#'  * `docker-compose`
#'
#' @param user Character vector for user name (defaults to "rods" admin)
#' @param pass Character vector for password (defaults to "rods" admin password)
#'
#' @references
#'  https://github.com/irods/irods_demo
#'
#' @return Invisible
#' @export
#'
#' @examples
#'
#' if (interactive()) {
#'
#'   # launch docker irods_demo containers (and possibly download images) with
#'   # default credentials.
#'   use_irods_demo()
#'
#'   # same but then with "alice" as user and "PASSword" as password
#'   use_irods_demo("alice", "PASSword")
#'
#'   # stop containers
#'   stop_irods_demo()
#' }
#'
use_irods_demo <- function(user = character(), pass = character()) {

  # check if Docker is installed and can be accessed without sudo rights
  if (Sys.which("bash") == "" ||
      Sys.which("docker") == ""  ||
      system("docker --version") == "" ||
      Sys.which("docker-compose") == "") {
    stop(
      "Bash and Docker with the docker-compose plugin are required. ",
      "Install bash and docker to commence. Alternatively, sudo rights ",
      "are required for Docker: please check: ",
      "https://docs.docker.com/engine/install/linux-postinstall/",
      call. = FALSE
    )
  }

  # does irods_demo exist
  irods_images <-
    system("docker image ls | grep irods_demo_",
           intern = TRUE,
           ignore.stderr = TRUE)
  irods_status <-
    try(attr(irods_images, "status") == 1, silent = TRUE
    )

  resp_user <- TRUE
  if (isTRUE(irods_status) ||
      !all(grepl(paste0(irods_images_ref, collapse = "|"), irods_images))) {
    resp_user <- utils::askYesNo(
      paste0(
        "The iRODS demo docker image is not build on this system.",
        "Would you like it be to build?"
      )
    )
  }

  # launch irods_demo
  if (isTRUE(resp_user)) {
    path_to_demo <- system.file("irods_demo", package = "rirods")
    system(
      paste0(
        "cd ",
        path_to_demo ,
        " ; docker-compose up -d nginx-reverse-proxy"
      )
    )
  }

  if (length(user) != 0 && length(pass) != 0) {

    # work from temporary directory
    local_create_irods()
    # authenticate
    iauth("rods", "rods")
    # add user
    iadmin(
      action = "add",
      target = "user",
      arg2 = user,
      arg3 = "rodsuser"
    )
    # modify password
    iadmin(
      action = "modify",
      target = "user",
      arg2 = user,
      arg3 = "password",
      arg4 = pass
    )
    withr::deferred_run()
  } else {
    user <- pass <- "rods"
  }

  message(
    "\n",
    "Do the following to connect with the iRODS demo server: \n",
    "create_irods(\"http://localhost/irods-rest/0.9.3\", \"tempZone/home\") \n",
    "iauth(\"", user, "\", \"", pass, "\")"
  )

  invisible()
}
#' @rdname use_irods_demo
#'
#' @export
stop_irods_demo <- function() {
  path_to_demo <- system.file("irods_demo", package = "rirods")
  system(paste0("cd ", path_to_demo, " ; docker-compose down"))
  invisible()
}
#' @rdname use_irods_demo
#'
remove_docker_images <- function() {
  system("docker compose down", intern = TRUE)
  system(paste0("docker image rm ", irods_images_ref, collapse = " && "),
         intern = TRUE)
  invisible()
}

# look up table for irods_demo images
irods_images_ref <- c(
  "irods_demo_irods-client-rest-cpp",
  "irods_demo_irods-catalog-provider",
  "irods_demo_irods-catalog",
  "irods_demo_nginx-reverse-proxy"
)
