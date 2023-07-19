#include "meminfo.h"
#include <fstream>
#include <string>

#ifdef WIN32
unsigned __int64 MemInfo::GetTotalMemSize()
{
  MEMORYSTATUSEX status;
  status.dwLength = sizeof(status);
  GlobalMemoryStatusEx(&status);
  return unsigned (__int64 (status.ullTotalPhys));
}
#elif defined(_SC_PHYS_PAGES)
unsigned long long MemInfo::GetTotalMemSize()
{
long long pages = sysconf(_SC_PHYS_PAGES);
long long page_size = sysconf(_SC_PAGE_SIZE);
return (pages * page_size);
}

#else
unsigned long long MemInfo::GetTotalMemSize()
{
std::ifstream meminfo("/proc/meminfo");
std::string line;
while (std::getline(meminfo, line))
{
  if (line.find("MemTotal") != std::string::npos)
  {
    unsigned long long total_mem_kB;
    std::sscanf(line.c_str(), "MemTotal:        %llu kB", &total_mem_kB);
    return total_mem_kB * 1024;  // Convert to bytes
  }
}
// If we didn't find the MemTotal line for some reason, return 0.
return 0;
}
#endif
