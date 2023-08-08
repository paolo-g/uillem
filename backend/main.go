package main

import (
	"log"
	"net/http"
	"backend/pkg/prompt"
)


func main() {
  http.HandleFunc("/prompt", prompt.HandleExec)
  if err := http.ListenAndServe(":8088", nil); err != nil {
    log.Fatal(err)
  }
}
