# README

Freescores is an application that provides access to the sheet music of a
single composer. By default, it is assumed that the composer intends to
distribute their music at no charge.

The central model in this application is the `work`. It has only three
mandatory fields: `title`, `composed_in`, and `link`, where `link` is the URL
path to a copy of the sheet music.

A `work` is linked to one or more instances of the `part` model. Each
`part` consists of an `instrument` and a `quantity`.

Things you may want to cover:

* Ruby version: 3.3.1

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
