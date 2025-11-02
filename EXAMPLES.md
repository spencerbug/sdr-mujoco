# MuJoCo Examples to Try

A collection of commands to explore MuJoCo's capabilities.

## 🎯 Hello World (Your Custom Program)

```bash
cd /root/sdr-mujoco/mujoco-hello-world/build
./hello_world ../model/simple_box.xml
```

## 🤖 Interactive Simulations

### Humanoid Robot
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/humanoid/humanoid.xml
```

**Controls in simulate:**
- Mouse drag: Rotate view
- Right-click drag: Pan view
- Scroll: Zoom
- Space: Pause/resume
- Backspace: Reset simulation
- Double-click: Select and track body

### Other Cool Models

#### Car Simulation
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/car/car.xml
```

#### Rubik's Cube
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/cube/cube_3x3x3.xml
```

#### Hammock (Soft Body)
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/hammock/hammock.xml
```

#### Balloons
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/balloons/balloons.xml
```

#### Playing Cards
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/cards/cards.xml
```

## 🔧 Plugin Examples

### SDF (Signed Distance Function) Primitives
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/plugin/sdf/primitives.xml
```

### Bowl with Objects
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/plugin/sdf/bowl.xml
```

### Nut and Bolt
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/plugin/sdf/nutbolt.xml
```

### Touch Grid Sensor
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/plugin/sensor/touch_grid.xml
```

### PID Actuator
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/plugin/actuator/pid.xml
```

### Elasticity - Cable
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/plugin/elasticity/cable.xml
```

## 🧪 Flex (Soft Body) Examples

### Bunny
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/flex/bunny.xml
```

### Gripper
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/flex/gripper.xml
```

### Trampoline
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/flex/trampoline.xml
```

### Flag
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/flex/flag.xml
```

## 📊 Sample Programs

### Basic Visualization Sample
```bash
/root/sdr-mujoco/install/bin/basic \
  /root/sdr-mujoco/install/share/mujoco/model/humanoid/humanoid.xml
```

### Test Model Speed
```bash
/root/sdr-mujoco/install/bin/testspeed \
  /root/sdr-mujoco/install/share/mujoco/model/humanoid/humanoid.xml
```

### Compile Model
```bash
/root/sdr-mujoco/install/bin/compile \
  /root/sdr-mujoco/install/share/mujoco/model/humanoid/humanoid.xml
```

## 🎨 Procedural Generation (Replicate)

### Newton's Cradle
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/replicate/newton_cradle.xml
```

### Bunnies
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/replicate/bunnies.xml
```

### Particle System
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/replicate/particle.xml
```

### Helix
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/replicate/helix.xml
```

### Stonehenge
```bash
/root/sdr-mujoco/install/bin/simulate \
  /root/sdr-mujoco/install/share/mujoco/model/replicate/stonehenge.xml
```

## 📝 Browse All Models

```bash
# List all available models
find /root/sdr-mujoco/install/share/mujoco/model -name "*.xml" -type f

# Count models
find /root/sdr-mujoco/install/share/mujoco/model -name "*.xml" -type f | wc -l

# Explore a category
ls /root/sdr-mujoco/install/share/mujoco/model/flex/
ls /root/sdr-mujoco/install/share/mujoco/model/plugin/
```

## 💡 Tips for Exploring

1. **Start Simple**: Begin with `simple_box.xml` or `humanoid.xml`

2. **Interactive Controls**: In simulate, use:
   - `F1`: Help (shows all keyboard shortcuts)
   - `F2`: Option panel
   - `F3`: Info panel
   - `F4`: Watch panel
   - `F5`: Visualization options

3. **Performance Testing**: Use `testspeed` to benchmark different models

4. **Learn from Source**: Check the XML files to understand model structure:
   ```bash
   cat /root/sdr-mujoco/install/share/mujoco/model/humanoid/humanoid.xml
   ```

5. **Copy and Modify**: Copy example models to your project and experiment:
   ```bash
   cp /root/sdr-mujoco/install/share/mujoco/model/car/car.xml \
      /root/sdr-mujoco/mujoco-hello-world/model/
   ```

## 🎓 Learning Progression

### Beginner
1. Run hello_world with different models
2. Explore interactive simulate
3. Modify simple XML models

### Intermediate
1. Study the sample C++ programs
2. Create custom models
3. Implement basic controllers

### Advanced
1. Build visualization applications
2. Use plugins and custom components
3. Optimize for performance

---

Enjoy exploring MuJoCo! 🚀
