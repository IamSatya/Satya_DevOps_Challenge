import nmap
    
def check_ssh_access_nmap(host):
        """
        Checks if SSH access is allowed on the specified host using nmap.
    
        Args:
            host (str): The hostname or IP address to check.
    
        Returns:
             bool: True if SSH access is not allowed, False otherwise.
        """
        nm = nmap.PortScanner()
        nm.scan(host, '22')
        if '22' in nm[host]['tcp']:
            if nm[host]['tcp'][22]['state'] == 'closed' or nm[host]['tcp'][22]['state'] == 'filtered':
                return True # SSH access is not allowed
            else:
                return False # SSH access is allowed
        else:
             return True # SSH access is not allowed
    
    # Example usage:
hostname = "130.107.9.70"
if check_ssh_access_nmap(hostname):
    print(f"SSH access is not allowed on {hostname}")
else:
    print(f"SSH access is allowed on {hostname}")
