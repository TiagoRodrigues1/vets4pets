package model

type ResendCommand struct {
    // We only need the email to initialize an email sendout
	Email string `json:"email" binding:"required"`
}