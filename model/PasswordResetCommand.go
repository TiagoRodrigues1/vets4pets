package model

type PasswordResetCommand struct {
	Token string `json:"token" binding:"required"`
	Password string `json:"password" binding:"required"`
	PasswordConfirm string `json:"passwordConfirm" binding:"required"`
}