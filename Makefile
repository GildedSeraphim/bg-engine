CFLAGS = -std=c++17 -O3 -I$(VULKAN_SDK)/include -I$(STB_INCLUDE_PATH)
LDFLAGS = -lglfw -lvulkan -ldl -lpthread -lX11 -lXxf86vm -lXrandr -lXi -Wall

VulkanTest: *.cpp *.hpp
		g++ $(CFLAGS) -o VulkanTest *.cpp $(LDFLAGS)

.PHONY: test clean

test: VulkanTest
	./VulkanTest

clean:
	rm -rf VulkanTest
