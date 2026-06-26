# Lesson 12 Exercises

This section documents exercises from lesson 12

---

### Exercise 1 - Service script manager

In this exercise, I had to write script `service_ctl.sh`.

The script manages a simple service task `sleep`.

#### Homework requirements

The script should have the commands:

```bash
./service_ctl.sh start   # Run service in the background

./service_ctl.sh stop    # Stop the service

./service_ctl.sh restart # Service restart

./service_ctl.sh status  # Check if service works
```

and also

`case` logic should be used for commands.

PID file to monitor the process.

`kill -0` to check if service is running.

Function `log()` with timestamp and levels of INFO/ERROR.

`trap cleanup EXIT` to delete PID file if error occurs.


### Script

`log()` function is just basic function that represents echo with timestamps and log arguments `$1` and `$2` so we can pass additional log informations.

`cleanup()` function is also used as a basic function to delete `$PID_FILE` and exit 1.

`trap cleanup EXIT` monitor start process and ends after saving PID to `$PID_FILE`, if in `start) case` would end with error it redirects to `cleanup()` function .

`$PID_FILE` shortcut for pid file path.

`start)` case, it runs our `sleep 9999 &` in the background.

`stop)` case, it check if the `$PID_FILE` exist if its true it kills the service process using PID read from `$PID_FILE`.

`restart)` case, uses `$0` to stop and start script service.

`status` case, it also checks if `$PID_FILE` exist, and if it exist then we have second `if` where we check with `kill -0` if the service is running or stopped, "if the file does not exist, service is considered stopped.

`*)` case, any other unknown command will exit 1 with `log()` error message.

### Output

By using commands given in homework requirements we can see:

```bash
sane@power-sane:~/first-devops-project/docs/Lesson-12$ bash ./service_ctl.sh start
Starting
2026-06-26 15:08 - INFO Service is running

sane@power-sane:~/first-devops-project/docs/Lesson-12$ bash ./service_ctl.sh status
2026-06-26 15:08 - INFO Service running

sane@power-sane:~/first-devops-project/docs/Lesson-12$ bash ./service_ctl.sh stop
Stopping
2026-06-26 15:08 - INFO Service stopped

sane@power-sane:~/first-devops-project/docs/Lesson-12$ bash ./service_ctl.sh status
2026-06-26 15:08 - INFO Service stopped

sane@power-sane:~/first-devops-project/docs/Lesson-12$ bash ./service_ctl.sh restart
2026-06-26 15:08 - INFO Service inactive
Starting
2026-06-26 15:08 - INFO Service is running

sane@power-sane:~/first-devops-project/docs/Lesson-12$ bash ./service_ctl.sh status
2026-06-26 15:08 - INFO Service running
```