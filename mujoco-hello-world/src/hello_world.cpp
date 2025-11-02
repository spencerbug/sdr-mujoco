// MuJoCo Hello World
// Simple example demonstrating basic MuJoCo usage
// Based on MuJoCo documentation: https://mujoco.readthedocs.io/en/stable/programming/

#include <cstdio>
#include <cstdlib>
#include <mujoco/mujoco.h>

int main(int argc, char** argv) {
  // Check command-line arguments
  if (argc != 2) {
    std::printf("Usage: %s <model.xml>\n", argv[0]);
    return 1;
  }

  // Activate MuJoCo
  char error[1000] = "Could not load model";
  
  // Load model from file
  mjModel* m = mj_loadXML(argv[1], NULL, error, 1000);
  if (!m) {
    std::printf("Load model error: %s\n", error);
    return 1;
  }

  // Make data corresponding to model
  mjData* d = mj_makeData(m);

  // Print model information
  std::printf("MuJoCo Hello World!\n");
  std::printf("Model loaded successfully: %s\n", argv[1]);
  std::printf("Number of bodies: %d\n", m->nbody);
  std::printf("Number of joints: %d\n", m->njnt);
  std::printf("Number of geoms: %d\n", m->ngeom);
  std::printf("Number of DOFs: %d\n", m->nv);
  std::printf("\n");

  // Run simulation for 10 seconds
  std::printf("Running simulation for 10 seconds...\n");
  int n_steps = 0;
  double simulation_time = 10.0;  // seconds
  
  while (d->time < simulation_time) {
    // Step the simulation
    mj_step(m, d);
    n_steps++;
  }

  std::printf("Simulation complete!\n");
  std::printf("Total steps: %d\n", n_steps);
  std::printf("Final time: %.3f seconds\n", d->time);
  std::printf("Timestep: %.5f seconds\n", m->opt.timestep);
  
  // Print final position of the box (body 1)
  if (m->nbody > 1) {
    std::printf("\nFinal position of box:\n");
    std::printf("  x: %.3f\n", d->xpos[3*1 + 0]);
    std::printf("  y: %.3f\n", d->xpos[3*1 + 1]);
    std::printf("  z: %.3f\n", d->xpos[3*1 + 2]);
  }

  // Free data and model
  mj_deleteData(d);
  mj_deleteModel(m);

  return 0;
}
