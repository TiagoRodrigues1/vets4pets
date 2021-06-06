package services

// Import relevant dependecy
import (
	"fmt"
	"net/smtp"
)


var auth smtp.Auth

func SendMail(to string, link string) bool {
	auth = smtp.PlainAuth("", "9ed3d7a612ebfa", "00a2949711abbb", "smtp.mailtrap.io")
	// Here we do it all: connect to our server, set up a message and send it
	
	r := NewRequest([]string{to},"Vet2Pet - Reset Password Link","teste","from@example.com")
	
	ok,_ := r.SendEmail(link)
		fmt.Println(ok)
		if ok == true {
			return true	
		}
		return false
	}
	

type Request struct {
	from    string
	to      []string
	subject string
	body    string
}

func NewRequest(to []string, subject, body string,from string) * Request {
	return &Request {
		to: to, 
		subject: subject,
		body:body,
		from: from,
	}
}

func (r *Request) SendEmail(link string) (bool, error) {
	//toString := strings.Join(r.to," ")
	mime := "MIME-version: 1.0;\nContent-Type: text/html; charset=\"UTF-8\";\n\n"
	subject := "Subject: " + r.subject + "!\r\n"
	r.body = "<html></head><body><p><a href="+ link +">Click here to reset your password</a></p></body></html>"
	msg := []byte(subject + mime + "\r\n" + r.body)
	if err := smtp.SendMail("smtp.mailtrap.io:2525",auth,"from@example.com", r.to,msg); err != nil {
		return false,err
	}
	return true,nil
}





