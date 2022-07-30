VULKAN_SDK_PATH = ../vulkansdk/1.2.189.0/x86_64
SHADERS_PATH = shaders
VERT = shader.vert
FRAG = shader.frag


CLFAGS = -std=c++17 -I$(VULKAN_SDK_PATH)/include
LFAGS = -std=c++17 -B$(VULKAN_SDK_PATH)/include

LDFLAGS = -L$(VULKAN_SDK_PATH)/lib `pkg-config --static --libs glfw3` -lvulkan

VulkanTest: main.cpp
	g++ $(CLFAGS) -ggdb -o VulkanTest main.cpp $(LDFLAGS)

VulkanTest-release: main.cpp
	g++ $(CLFAGS) -O3 -o VulkanTest-release main.cpp $(LDFLAGS)


$(SHADERS_PATH)/$(VERT).spv: $(SHADERS_PATH)/$(VERT)
	$(VULKAN_SDK_PATH)/bin/glslc $(SHADERS_PATH)/$(VERT) -o $(SHADERS_PATH)/$(VERT).spv

$(SHADERS_PATH)/$(FRAG).spv: $(SHADERS_PATH)/$(FRAG)
	$(VULKAN_SDK_PATH)/bin/glslc $(SHADERS_PATH)/$(FRAG) -o $(SHADERS_PATH)/$(FRAG).spv

clang: main.cpp
	x86_64-w64-mingw32-g++-win32 $(LFAGS) -ggdb -o VulkanTest main.cpp $(LDFLAGS)

.PHONY: clean test build-all test-release

test: VulkanTest $(SHADERS_PATH)/$(VERT).spv  $(SHADERS_PATH)/$(FRAG).spv
	LD_LIBRARY_PATH=$(VULKAN_SDK_PATH)/lib 
	VK_LAYER_PATH=$(VULKAN_SDK_PATH)/etc/vulkan/explicit_layer.d 
	./VulkanTest

test-release: VulkanTest-release $(SHADERS_PATH)/$(VERT).spv  $(SHADERS_PATH)/$(FRAG).spv
	LD_LIBRARY_PATH=$(VULKAN_SDK_PATH)/lib 
	VK_LAYER_PATH=$(VULKAN_SDK_PATH)/etc/vulkan/explicit_layer.d 
	./VulkanTest-release

clean:
	rm -f VulkanTest
	rm -f VulkanTest-release
	rm -f shaders/*.spv
