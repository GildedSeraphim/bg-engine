{
  description = "Vulkan Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        lib = nixpkgs.lib;
        pkgs = import nixpkgs {
          system = "${system}";
          config = {
            allowUnfree = true;
            nvidia.acceptLicense = true;
          };
        };
      in rec {
        devShells = {
          default = pkgs.mkShell rec {
            buildInputs = with pkgs; [
              ##################
              ### VULKAN SDK ###
              vulkan-headers
              vulkan-loader
              vulkan-validation-layers
              vulkan-tools
              vulkan-tools-lunarg
              vulkan-utility-libraries
              vulkan-extension-layer
              vulkan-volk
              vulkan-validation-layers
              spirv-headers
              spirv-tools
              spirv-cross
              mesa
              glslang
              ##################

              ####################
              ### Compat Tools ###
              xorg.libX11
              xorg.libXrandr
              xorg.libXcursor
              xorg.libXi
              xorg.libXxf86vm
              xorg.libXinerama
              wayland
              wayland-protocols
              kdePackages.qtwayland
              kdePackages.wayqt
              ####################

              #################
              ### Libraries ###
              glfw3
              glfw
              glm
              vulkan-memory-allocator
              vk-bootstrap

              imgui
              stb
              tinyobjloader

              libGLU
              libGL
              libxkbcommon

              SDL2
              SDL2_ttf

              pkg-config

              boost
              catch2
              #################

              #################
              ### Compilers ###
              shaderc
              gcc
              clang
              #################
            ];

            packages = with pkgs; [
              (writeShellApplication {
                name = "compile-shaders";
                text = ''
                  exec ${shaderc.bin}/bin/glslc shader.vert -o vert.spv &
                  exec ${shaderc.bin}/bin/glslc shader.frag -o frag.spv
                '';
              })
              (writeShellApplication {
                ## Lets renderdoc run on wayland using xwayland
                name = "renderdoc";
                text = "QT_QPA_PLATFORM=xcb qrenderdoc";
              })

              #############
              ### Tools ###
              renderdoc
              cmake
              glslviewer
              #############
            ];

            LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
            VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
            VULKAN_SDK = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
            XDG_DATA_DIRS = builtins.getEnv "XDG_DATA_DIRS";
            XDG_RUNTIME_DIR = "/run/user/1000";
            STB_INCLUDE_PATH = "./headers/stb";
            #VULKAN_SDK = "/home/sn/Vulkan/1.3.296.0/x86_64";
          };
        };
      }
    );
}
