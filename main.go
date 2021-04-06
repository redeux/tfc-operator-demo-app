package main

import (
	"html/template"
	"io/ioutil"
	"log"
	"net/http"
)

var tpl *template.Template

func secretHandler(w http.ResponseWriter, r *http.Request) {
	files, err := ioutil.ReadDir("/etc/secret_demo/")

	if err != nil || len(files) == 0 {

		err = tpl.ExecuteTemplate(w, "secret.gohtml", map[string]string{
			"Error": "No secrets detected",
		})
		check(err)
	} else {

		dat := map[string]string{}
		for _, file := range files {
			fileName := file.Name()
			con, err := ioutil.ReadFile("/etc/secret_demo/" + fileName)
			check(err)

			dat[fileName] = string(con)
		}

		err = tpl.ExecuteTemplate(w, "secret.gohtml", dat)
		check(err)
	}
}

func init() {
	tpl = template.Must(template.ParseGlob("views/*.gohtml"))
}

func main() {
	http.Handle("/", http.FileServer(http.Dir(".")))
	http.HandleFunc("/secret", secretHandler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}

func check(e error) {
	if e != nil {
		log.Fatal(e)
	}
}
