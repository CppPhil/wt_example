#include "hello_application.hpp"

int main(int argc, char* argv[])
{
  return WRun(argc, argv, [](const WEnvironment& environment) {
    return mu<we::HelloApplication>(environment);
  });
}
