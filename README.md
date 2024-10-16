<h1 align="center">Yiimpool Yiimp Installer with DaemonBuilder and Addport Support</h1>

<p align="center">
  <img alt="Discord" src="https://img.shields.io/discord/904564600354254898?label=Discord">
  <img alt="GitHub issues" src="https://img.shields.io/github/issues/afiniel/yiimp_install_script">
  <img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/afiniel/yiimp_install_script">
</p>

<p align="center">
  <img src="./.assets/motd.png" alt="motd" width="500" height="450">
</p>

<h2 align="center">Description</h2>
<p>Yiimpool Yiimp Installer is an automated script that sets up a fully functional Yiimp mining pool on an Ubuntu 18.04 or 20.04 VPS. The script includes necessary dependencies, configurations, and security settings to get your pool up and running. Features include:</p>
<ul>
  <li>Automatic coin daemon compilation using DaemonBuilder</li>
  <li>Support for custom ports</li>
  <li>SSL certificate installation from Let's Encrypt</li>
  <li>Intuitive web interface for managing your pool</li>
</ul>
<p>Designed for both new and experienced users with clear installation instructions and comprehensive documentation.</p>

<h2>⚙️ Requirements</h2>
<ul>
  <li>Fresh Ubuntu 18.04 or 20.04 VPS</li>
  <li>Minimum 8GB RAM</li>
</ul>

<h2>ℹ️ DaemonBuilder</h2>
<p>A tool that downloads and compiles coins. To use, type <code>daemonbuilder</code> in the terminal. Compile time depends on VPS CPU power.</p>

<h2>💾 Installation</h2>
<h3>Installer will ask:</h3>
<ul>
  <li>Using domain name</li>
  <li>Using sub-domain as main domain?</li>
  <li>Domain Name</li>
  <li>Stratum Domain</li>
  <li>Install SSL</li>
  <li>Support Email</li>
  <li>Public IP</li>
  <li>DB Root Password</li>
  <li>DB Panel User Password</li>
  <li>DB Stratum Password</li>
  <li>Admin Portal Access Location</li>
  <li>Stratum to be built with autoexchange enable</li>
</ul>

<h3>To install:</h3>
<pre><code>curl https://raw.githubusercontent.com/afiniel/Yiimpoolv1/master/install.sh | sudo bash</code></pre>
<p>Installation will take approximately 15 minutes. The installer will notify you when the installation is complete. If you encounter any issues, open an issue on GitHub.</p>

<h3>Finish!</h3>
<h4>A server reboot is REQUIRED after the installation is fully completed to finalize the installation process.</h4>
<p>After rebooting, log back into your user account. The installation process is complete when you log in again. On first reboot, it may take 1-2 minutes for the cron screens to auto-start. After waiting 1-2 minutes, type:</p>
<pre><code>motd</code></pre>

<p>To enhance security, the install locations and directory structure of YiiMP have been changed as follows:</p>
<table>
  <thead>
    <tr>
      <th>Directory</th>
      <th>Files</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><pre>/home/crypto-data/yiimp</pre></td>
      <td>General install location for YiiMP</td>
    </tr>
    <tr>
      <td><pre>/home/crypto-data/yiimp/starts</pre></td>
      <td>Screens and stratum sh files - you do not need to run these</td>
    </tr>
    <tr>
      <td><pre>/home/crypto-data/yiimp/site</pre></td>
      <td>-</td>
    </tr>
    <tr>
      <td><pre>/home/crypto-data/yiimp/site/web</pre></td>
      <td>New location for YiiMP web files</td>
    </tr>
    <tr>
      <td><pre>/home/crypto-data/yiimp/site/backup</pre></td>
      <td>Backup location for MySQL DB</td>
    </tr>
    <tr>
      <td><pre>/home/crypto-data/yiimp/site/configuration</pre></td>
      <td>New location of your serverconfig.php</td>
    </tr>
    <tr>
      <td><pre>/home/crypto-data/yiimp/site/crons</pre></td>
      <td>New location of the "main:blocks:loop2" sh files</td>
    </tr>
    <tr>
      <td><pre>/home/crypto-data/yiimp/site/log</pre></td>
      <td>New location for debug.log and your nginx server log</td>
    </tr>
    <tr>
      <td><pre>/home/crypto-data/yiimp/site/stratum</pre></td>
      <td>New location for your stratum files</td>
    </tr>
  </tbody>
</table>
<p>Permissions have been correctly set up, allowing your main user write access to the /home/crypto-data directories. Changing file or directory permissions after installation will cause YiiMP to malfunction. You have been warned!</p>

<h3>Commands</h3>
<p>To view your running screens, run:</p>
<pre><code>screen -list</code></pre>
<p>To view a specific screen, run:</p>
<pre><code>screen -r main|loop2|blocks|debug</code></pre>
<p>To detach from a screen, type:</p>
<pre><code>ctrl+a+d</code> (DO NOT use ctrl+c, it will kill your screen)</pre>
<p>To start, stop, or restart a specific screen (main, loop2, blocks, or debug), type:</p>
<pre><code>screens start|stop|restart main|loop2|blocks|debug</code></pre>
<p>We also suggest typing:</p>
<pre><code>yiimp</code></pre>

<h3>Support</h3>
<p>If you want to support our project, you can make a donation to any of the following addresses:</p>
<ul>
  <li>BTC: bc1qc4qqz8eu5j7u8pxfrfvv8nmcka7whhm225a3f9</li>
  <li>ETH: 0xdA929d4f03e1009Fc031210DDE03bC40ea66D044</li>
  <li>LTC: ltc1qma2lgr2mgmtu7sn6pzddaeac9d84chjjpatpzm</li>
  <li>DOGE: D79wmvtDSaNsJPgAz26GYC39LhYbyqXSNL</li>
  <li>SOLANA: 4Akj4XQXEKX4iPEd9A4ogXEPNrAsLm4wdATePz1XnyCu</li>
  <li>KASPA: kaspa:qqdwrqfn6n0hf0gsycrqqmv8z7x6s0wgh4x6kat6nzgyksf525w0ups70mrz0</li>
  <li>BEP-20: 0xdA929d4f03e1009Fc031210DDE03bC40ea66D044</li>
  <li>Polygon: 0xdA929d4f03e1009Fc031210DDE03bC40ea66D044</li>
</ul>
<p>We appreciate your generosity and support. Thank you!</p>
