extends CanvasLayer

signal start_song
signal start_countdown
signal sound_metronome
# Variable for Countdown timer
var CountdownTimer
# there's probably a better way to do the timer
var TimerCount = 4


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Start the countdown
func song_countdown(bpm):
	print("countdown time")
	emit_signal("sound_metronome")
	
	# Start a new one second timer
	CountdownTimer = Timer.new()
	add_child(CountdownTimer)
	var BeatLength = 1/(bpm/60.0)
	CountdownTimer.autostart = true
	CountdownTimer.wait_time = BeatLength
	CountdownTimer.connect("timeout", self, "_timeout")	
	CountdownTimer.start()

# On timer timeout
func _timeout():
	print("TimerGone")
	# Decrement the timer amount
	TimerCount -= 1
	# If timer has run out, start the song
	if TimerCount == 0:
		emit_signal("start_song")
		$CountdownLabel.hide()
		CountdownTimer.stop()
	else:
		emit_signal("sound_metronome")
		$CountdownLabel.text = String(TimerCount)
	
	


func _on_StartButton_pressed():
	$StartButton.hide()
	emit_signal("start_countdown")
	
func update_streak(streak):
	$StreakLabel.text = str("Streak: ", streak)

func update_score(score):
	$ScoreLabel.text = str("Score: ", score)
