#include <iostream>
#include <fstream>
#include <filesystem>

namespace fs = std::filesystem;

std::ifstream read_input(int day);
std::ifstream read_input(int day)
{
  std::ifstream input(fs::path("inputs") / std::to_string(day) / std::string(".txt"));

  std::cout << (fs::path("inputs") / std::to_string(day) / std::string(".txt")) << std::endl;

  return input;
}