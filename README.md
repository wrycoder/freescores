# README

Freescores is an application that provides access to the sheet music of a
single composer. By default, it is assumed that the composer intends to
distribute their music at no charge.

The central model in this application is the `work`. It has only two
mandatory fields: `title` and `composed_in`.

A `work` is linked to one or more instances of the `part` model. Each
`part` consists of an `instrument` and a `quantity`. No `work` is considered
valid until it has at least one associated `part`.

A `work` may have one or more associated `score` records. Each
`score` is a PDF copy of the sheet music for the entire work, or an
individual movement.

A `work` may have one or more associated `recording`s. Each
`recording` is an MP3 recording of the entire work, or of a single
movement.

* Ruby version: 3.3.1

* Database initialization

* Deployment instructions

    The file `local-bin/fsenv` is a shell script that will
    set the four environment variables required by the system:

      * ADMIN_PASSWORD - for access to the dashboard
      * APP_HOST       - the server that hosts freescores
      * MEDIA_HOST     - the server hosting the composer's scores 
                         and recordings
      * FILE_ROOT      - subdirectory on MEDIA_HOST containing the scores
                         and recordings
