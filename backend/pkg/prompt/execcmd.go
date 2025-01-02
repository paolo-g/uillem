package prompt

import (
  "bytes"
  "fmt"
  "net/http"
  "os"
  "os/exec"
  "strconv"
  "strings"
)


var blocking bool = false
func unblock() {
  blocking = false
}

var cache = make(map[string]string)

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

  // Gather request parameters
  req.ParseForm()
  args := []string{"-m", os.ExpandEnv("./models/$MODEL_FILENAME"),
//                      "--n-predict", "-1",
//                      "--repeat-penalty", "1.3",
//                      "--temp", "0.1",
                      "--threads", os.ExpandEnv("$THREAD_LIMIT"),
//                      "--top_k", "10000"
                      }

  // Batch size
  var batch_size_str string
  if bs, ok := req.Form["batch_size"]; ok {
    batch_size_str = strings.Join(bs, "")
    _, err := strconv.Atoi(batch_size_str) // Must be an integer
      if err != nil {
        fmt.Println("Provided batch size is not an integer", batch_size_str)
        w.WriteHeader(400)
        w.Write([]byte("Bad Request"))
        return
      }
  }
  if len(batch_size_str) > 0 {
    args = append(args, "-b", batch_size_str)
  }

  // Context size
  var ctx_size_str string
  if cs, ok := req.Form["ctx_size"]; ok {
    ctx_size_str = strings.Join(cs, "")
    _, err := strconv.Atoi(ctx_size_str) // Must be an integer
      if err != nil {
        fmt.Println("Provided context size is not an integer", ctx_size_str)
        w.WriteHeader(400)
        w.Write([]byte("Bad Request"))
        return
      }
  }
  if len(ctx_size_str) > 0 {
    args = append(args, "--ctx-size", ctx_size_str)
  }

  // Prompt
  var prompt string
  if p, ok := req.Form["p"]; ok {
    prompt = strings.Join(p, " ")
  }
  prompt_len := len(prompt) // Non-zero length
  if prompt_len == 0 {
    fmt.Println("Empty prompt")
    w.WriteHeader(400)
    w.Write([]byte("Bad Request"))
    return
  }
  prompt = strings.Replace(prompt, "\"", "", -1) // Escape double quotes
  args = append(args, "--prompt", fmt.Sprintf("\"%s\"", prompt))
  fmt.Println("Prompting with:", prompt)

  // Check if we already handled this prompt
  if hit, ok := cache[prompt]; ok {
    fmt.Println("Found response in cache:", hit)
    w.Write([]byte(hit))
    return
  }

  // Call llama.cpp and collect output from selected model
  fmt.Println("main() args:", strings.Join(args, " "))
  cmd := exec.Command("./build/bin/llama-cli", args...)
  var out bytes.Buffer
  var stderr bytes.Buffer
  cmd.Stdout = &out
  cmd.Stderr = &stderr
  err := cmd.Run()
  if err != nil {
    fmt.Println(fmt.Sprint(err) + ": " + stderr.String())

    w.WriteHeader(500)
    w.Write([]byte("Server Error"))
    return
  }
  var output = string(out.String())
  response := string(output[:])
  fmt.Println("Response:", response)

  // Add response to cache map and return
  cache[prompt] = response
  w.Write([]byte(response))
  return
}
