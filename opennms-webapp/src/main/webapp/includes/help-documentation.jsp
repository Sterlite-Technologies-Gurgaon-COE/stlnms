<%@ page import="org.opennms.core.resource.Vault" %><%--
/*******************************************************************************
 * This file is part of STL-NMS(R).
 *
 * Copyright (C) 2002-2018 The STL-NMS Group, Inc.
 * STL-NMS(R) is Copyright (C) 1999-2018 The STL-NMS Group, Inc.
 *
 * STL-NMS(R) is a registered trademark of The STL-NMS Group, Inc.
 *
 * STL-NMS(R) is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * STL-NMS(R) is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with STL-NMS(R).  If not, see:
 *      http://www.gnu.org/licenses/
 *
 * For more information contact:
 *     STL-NMS(R) Licensing <license@opennms.org>
 *     http://www.opennms.org/
 *     http://www.opennms.com/
 *******************************************************************************/
--%>

<script type="text/javascript">
    // Shorthand for 'onload'
    $(function () {
        // Check to see if the URL provided by the opennms-docs package is present on the system.
        // If so, display the links to the offline docs symlinked from /usr/share/doc/opennms-${version}.
        $.ajax({
            url: 'docs/guide-install/index.html',
            method: 'HEAD',
            error: function () {
                $('#online-documentation').css("display", "inline-block");
            },
            success: function () {
                $('#offline-documentation').css("display", "inline-block");
            }
        });
    });
</script>

<div class="card">
    <div class="card-header">
        <span>Documentation</span>
    </div>
    <div class="card-body">
        <span id="online-documentation" style="display:none;">
            <table class="table">
                <tr>
                    <td style="border-top: none;"><a
                            href="https://docs.opennms.org/opennms/releases/<%=Vault.getProperty("version.display")%>/guide-install/guide-install.html"
                            target="_blank" class="btn btn-secondary" role="button"
                            style="width: 100%">Installation Guide</a></td>
                    <td style="border-top: none;">STL-NMS can be installed several operating systems and can be deployed for several scenarios with different technologies. Have a look in the Installation Guide to find instructions to deploy and maintain your STL-NMS instance.</td>
                </tr>
                <tr>
                    <td style="border-top: none;"><a
                            href="https://docs.opennms.org/opennms/releases/<%=Vault.getProperty("version.display")%>/guide-admin/guide-admin.html"
                            target="_blank" class="btn btn-secondary" role="button"
                            style="width: 100%">Admin Guide</a></td>
                    <td style="border-top: none;">Have a look into the Admin Guide to find instructions how to configure STL-NMS to monitor your infrastructure and services.</td>
                </tr>
                <tr>
                    <td style="border-top: none;"><a
                            href="https://docs.opennms.org/opennms/releases/<%=Vault.getProperty("version.display")%>/guide-development/guide-development.html"
                            target="_blank" class="btn btn-secondary" role="button"
                            style="width: 100%">Developers Guide</a></td>
                    <td style="border-top: none;">Developers can extend and improve the STL-NMS platform. The Developers Guide is a good starting point for extending STL-NMS and using the ReST APIs for integration.</td>
                </tr>
                <tr>
                    <td style="border-top: none;"><a href="https://wiki.opennms.org" target="_blank"
                                                     class="btn btn-secondary" role="button" style="width: 100%">STL-NMS Wiki</a></td>
                    <td style="border-top: none;">With the large variety of devices and applications you can monitor with STL-NMS, the Wiki provides space to share experience with How Tos and Tutorials to address specific use cases.</td>
                </tr>
                <tr>
                    <td style="border-top: none;"><a
                            href="https://opennms.discourse.group/t/community-welcome-guide/560" target="_blank"
                            class="btn btn-secondary" role="button" style="width: 100%">Welcome Guide</a></td>
                    <td style="border-top: none;">If you are new in the project, you can find useful information in your Welcome Guide to get anything you need to get started.</td>
                </tr>
            </table>
        </span>
        <span id="offline-documentation" style="display:none;">
            <table class="table">
                <tr>
                    <td style="border-top: none;"><a href="docs/guide-install/index.html" target="_blank"
                                                     class="btn btn-secondary" role="button" style="width: 100%">Installation Guide</a></td>
                    <td style="border-top: none;">STL-NMS can be installed several operating systems and can be deployed for several scenarios with different technologies. Have a look in the Installation Guide to find instructions to deploy and maintain your STL-NMS instance.</td>
                </tr>
                <tr>
                    <td style="border-top: none;"><a href="docs/guide-admin/index.html" target="_blank"
                                                     class="btn btn-secondary" role="button" style="width: 100%">Admin Guide</a></td>
                    <td style="border-top: none;">Have a look into the Admin Guide to find instructions how to configure STL-NMS to monitor your infrastructure and services.</td>
                </tr>
                <tr>
                    <td style="border-top: none;"><a href="docs/guide-development/index.html" target="_blank"
                                                     class="btn btn-secondary" role="button" style="width: 100%">Developers Guide</a></td>
                    <td style="border-top: none;">Developers can extend and improve the STL-NMS platform. The Developers Guide is a good starting point for extending STL-NMS and using the ReST APIs for integration.</td>
                </tr>
                <tr>
                    <td style="border-top: none;"><a href="" target="_blank"
                                                     class="btn btn-secondary" role="button" style="width: 100%">STL-NMS Wiki</a></td>
                    <td style="border-top: none;">With the large variety of devices and applications you can monitor with STL-NMS, the Wiki provides space to share experience with How Tos and Tutorials to address specific use cases.</td>
                </tr>
                <tr>
                    <td style="border-top: none;"><a
                            href="https://opennms.discourse.group/t/community-welcome-guide/560" target="_blank"
                            class="btn btn-secondary" role="button" style="width: 100%">Welcome Guide</a></td>
                    <td style="border-top: none;">If you are new in the project, you can find useful information in your Welcome Guide to get anything you need to get started.</td>
                </tr>
            </table>
        </span>
    </div>
</div>
