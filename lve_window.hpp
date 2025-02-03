#pragma once

#include <cstdint>
#include <vulkan/vulkan_core.h>
#define GLFW_INCLUDE_VULKAN
#include <GLFW/glfw3.h>

#include <string>

namespace lve {
class LveWindow {
public:
  LveWindow(int w, int h, std::string name);
  ~LveWindow();

  // Removes dangling pointer
  LveWindow(const LveWindow &) = delete;
  LveWindow &operator=(const LveWindow &) = delete;

  bool shouldClose() { return glfwWindowShouldClose(window); }
  VkExtent2D getExtent() {
    return {static_cast<uint32_t>(width), static_cast<uint32_t>(height)};
  }
  bool wasWindowResized() { return frameBufferResized; }
  void resetWindowResizedFlag() { frameBufferResized = false; }

  void createWindowSurface(VkInstance instance, VkSurfaceKHR *surface);

private:
  static void frameBufferResizedCallback(GLFWwindow *window, int width,
                                         int height);
  void initWindow();

  int width;
  int height;
  bool frameBufferResized = false;

  std::string windowName;
  GLFWwindow *window;
};
} // namespace lve
