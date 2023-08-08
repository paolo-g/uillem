package prompt

import (
  "fmt"
	"log"
	"net/http"
	"os"
	"os/exec"
	"strings"
)


var blocking bool = false
func unblock() {
  blocking = false
}

var cache = make(map[string]string)

const Promptlimit = 255

func HandleExec(w http.ResponseWriter, req *http.Request) {
  w.Header().Set("Content-Type", "text/plain; charset=utf-8")
  w.Header().Set("Access-Control-Allow-Origin", "*")

  // Only allow one concurrent execution
  if blocking {
    w.WriteHeader(503)
    w.Write([]byte("Service Unavailable"))
    return
  }
  defer unblock()
  blocking = true

  // Gather user's input prompt
  var prompt string
  req.ParseForm()
  if p, ok := req.Form["p"]; ok {
    prompt = strings.Join(p, " ")
  } else {
    // Prompt does not exist
    w.WriteHeader(400)
    w.Write([]byte("Bad Request"))
    return
  }

  // Limit prompt length
  if len(prompt) > Promptlimit {
    prompt = prompt[0:Promptlimit]
  }

  // Sanitize prompt
  prompt = strings.Replace(prompt, "`", "'", -1)
  prompt = strings.Replace(prompt, "&", " and ", -1)
  prompt = strings.Replace(prompt, "$", "£", -1)
  prompt = strings.Replace(prompt, "(", " ", -1)
  prompt = strings.Replace(prompt, "[", " ", -1)
  prompt = strings.Replace(prompt, "{", " ", -1)
  prompt = strings.Replace(prompt, ";", ".", -1)
  prompt = strings.Replace(prompt, "<", "", -1)
  prompt = strings.Replace(prompt, ">", "", -1)
  prompt = strings.Replace(prompt, "|", "/", -1)
  prompt = strings.Replace(prompt, "\\", "/", -1)

  fmt.Println("Prompting with:", prompt)

  // Check if we already handled this prompt
  if response, ok := cache[prompt]; ok {
    fmt.Println("Found response in cache:", response)
    w.Write([]byte(response))
    return
  }

  // Call llama.cpp and collect output from selected model
  args := []string{"-m", os.ExpandEnv("./models/$MODEL_FILENAME"),
                    "-b", "256",
                    "--ctx-size", "4096",
                    "--n-predict", "-1",
                    "--repeat-penalty", "1.3",
                    "--temp", "0.1",
                    "--threads", os.ExpandEnv("$THREAD_LIMIT"),
                    "--top_k", "10000",
                    "--prompt", prompt}
  output, err := exec.Command("./main", args...).Output()
  if err != nil {
    w.WriteHeader(500)
    w.Write([]byte("Server Error"))
    log.Fatal(err)
    return
  }
  var stringoutput string = string(output[:])

  // Model may return the query prompt in the first paragraph, strip it out if so
  var responsearray []string
  for _, paragraph := range strings.Split(stringoutput, "\n") {
    index := strings.Index(strings.ToLower(paragraph), strings.ToLower(prompt))
    if index == -1 {
      responsearray = append(responsearray, paragraph)
    }
  }

  // Format response
  var response string = strings.Join(responsearray, "\n")
  fmt.Println("Response:", response)

  // Add response to cache map and return
  cache[prompt] = response
  w.Write([]byte(response))
  return
}
