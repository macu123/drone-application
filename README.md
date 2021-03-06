# drone-application
## Space Coordinates
## ![Screen Shot 2021-06-21 at 00 50 31](https://user-images.githubusercontent.com/2754653/122709420-397fc180-d22c-11eb-8c69-1504a59396dd.png)

## Engines Positions
![Screen Shot 2021-06-21 at 00 59 39](https://user-images.githubusercontent.com/2754653/122709496-6338e880-d22c-11eb-8f41-4a4b516b4ee4.png)

## How to move Drone using Engines
- High engine power means faster speed, and low engine power means slower speed.
- In order to move forward along Y axis, engine 0 and 1 should have low power while engine 2 and 3 should have high power.
- In order to move backward along Y axis, engine 2 and 3 should have low power while engine 0 and 1 should have high power.
- In order to move leftward along X axis, engine 0 and 2 should have low power while engine 1 and 3 should have high power.
- In order move rightward along X axis, engine 1 and 3 should have low power while engine 0 and 2 should have high power.
- In order to move upward along Z axis, all engines should have high power.
- In order to move downward along Z axis, all engines should have low power.
- In order to stabilize, all engines should have certain power between low and high because the drone has weight.
- For simplicity, we preset those low, high, stable and landing powers, we also assume power and speed are the same.

## Reference
https://www.youtube.com/watch?v=uFui-0sTQD0
