#pragma once

#include "lve_device.hpp"
#include <vulkan/vulkan_core.h>

#define GLM_FORCE_RADIANS
#define GLM_FORCE_DEPTH_ZERO_TO_ONE
#include <glm/glm.hpp>

#include <vector>

namespace lve {
class LveModel {
public:
  struct Vertex {
    glm::vec3 position;
    glm::vec3 color;

    static std::vector<VkVertexInputBindingDescription>
    getBindingDescriptions();
    static std::vector<VkVertexInputAttributeDescription>
    getAttributeDescriptions();
  };

  LveModel(LveDevice &lveDevice, const std::vector<Vertex> &vertices);
  ~LveModel();

  LveModel(const LveModel &) = delete;
  LveModel &operator=(const LveModel &) = delete;

  void bind(VkCommandBuffer commandBuffer);
  void draw(VkCommandBuffer commandBuffer);

private:
  void createVertexBuffers(const std::vector<Vertex> &vertices);

  LveDevice &lveDevice;
  VkBuffer vertexBuffer;
  VkDeviceMemory vertexBufferMemory;
  uint_fast32_t vertexCount;
};
} // namespace lve
