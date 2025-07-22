#!/usr/bin/python3

import time

def run_loop_for_seconds(seconds):
    start_time = time.time()

    while time.time() - start_time < seconds:
        # Your code inside the loop
        print("Looping...",time.time() - start_time)

        # You can add more logic or tasks here

        time.sleep(1)  # Adjust the sleep time as needed

    print("Loop completed.")

# Example: Run the loop for 10 seconds
    
run_loop_for_seconds(15)