# dependency management
options(renv.settings.snapshot.type = "explicit")
source("renv/activate.R")

# development key (create key with httr2::secret_make_key() and place in user
# level environment variables. One can use usethis::edit_r_environ() for this.
# Store the key under "DEV_KEY_IRODS")

# irods environment variables for development
Sys.setenv(DEV_HOST_IRODS = "itxgo_ZF5Ncd79rj1OKLC2i_0z0D7gYgWZj1JbZN7sQe28QyICI6piF5sZyiW0ITmRYCqvh9")
Sys.setenv(DEV_ZONE_PATH_IRODS = "pDRzU24ysv8w1_bSIy6WXFZVJk2Sl2weSv9k2PI")
Sys.setenv(DEV_USER = "ZGlORquE2G6BIPS5JAcuPcngmBB6Wg")
Sys.setenv(DEV_PASS = "ZGlORquE2G6BIPS5JAcuPcngmBB6Wg")

# replace scrambled server information with real information
if (requireNamespace("httr2", quietly = TRUE)) {

  fill_environ <- function() {
    # get user
    user <- try(httr2::secret_decrypt(Sys.getenv("DEV_USER"), "DEV_KEY_IRODS"), silent = TRUE)
    if (inherits(user, "try-error")) {
      Sys.setenv(DEV_USER = "rods")
    } else {
      Sys.setenv(DEV_USER = user)
    }
    # get password
    pass <- try(httr2::secret_decrypt(Sys.getenv("DEV_PASS"), "DEV_KEY_IRODS"), silent = TRUE)
    if (inherits(pass, "try-error")) {
      Sys.setenv(DEV_PASS = "rods")
    } else {
      Sys.setenv(DEV_PASS = pass)
    }
    # get logical path
    lpath <- try(httr2::secret_decrypt(Sys.getenv("DEV_ZONE_PATH_IRODS"), "DEV_KEY_IRODS"), silent = TRUE)
    if (inherits(lpath, "try-error")) {
      Sys.setenv(DEV_ZONE_PATH_IRODS = "/tempZone/home")
    } else {
      Sys.setenv(DEV_ZONE_PATH_IRODS = lpath)
    }
    # get host
    host <- try(httr2::secret_decrypt(Sys.getenv("DEV_HOST_IRODS"), "DEV_KEY_IRODS"), silent = TRUE)
    if (inherits(host, "try-error")) {
      Sys.setenv(DEV_HOST_IRODS = "http://localhost/irods-rest/0.9.3")
      # fire up irods demo
      # use_irods_demo("up")
    } else {
      Sys.setenv(DEV_HOST_IRODS = host)
    }
  }

  use_irods_demo <- function(action = "up") {

    # does it exist
    pt <- system("find ~ -path ~/.local  -prune -o -type d -name 'irods_demo' -print", intern = TRUE)
    if (length(pt) == 0)
      warning("The iRODS demo is not installed on this system. Using http mock files instead.", call. = FALSE)

    if (action == "up") {
      system(paste0("cd ",pt ," ; docker-compose up -d nginx-reverse-proxy"))
    } else if (action == "down") {
      system(paste0("cd ",pt ," ; docker-compose down"))
    } else {
      stop("Action unkown.", call. = FALSE)
    }
  }

  fill_environ()
}
